#!/usr/bin/perl

use strict;
use warnings;

use lib 'lib';

use File::Basename ();
use Path::Class::Dir ();
use SixteenColors;

my $c      = 'SixteenColors';
my $schema = $c->model( 'DB' )->schema;
my $rs     = $c->model( 'DB::Pack' );

if( !@ARGV ) {
    print <<"EOUSAGE"
USAGE: $0 /path/to/archive/sorted/by/year/
       $0 year /path/to/directory/
       $0 year /path/to/file.ext
EOUSAGE
}
elsif( -d $ARGV[ 0 ] ) {
    my $dir = Path::Class::Dir->new( shift );
    my @years = sort map { $_->basename }
        grep { $_->is_dir && $_->basename =~ m{^\d{4}$} }
        $dir->children( no_hidden => 1 );
    _index_dir( $_, $dir->subdir( $_ ) ) for @years;
}
else {
    my $year = shift;
    my @files = @ARGV;

    unless ( $year =~ m{^\d\d\d\d$} ) {
        print "[ERROR] Invalid year specified\n";
        exit;
    }

    if( @files == 1 && -d $files[ 0 ] ) {
        _index_dir( $year, @files );
    }
    else {
        _index( $year, @files );
    }
}

sub _index_dir {
    my $year  = shift;
    my $dir   = Path::Class::Dir->new( shift );
    my @files = map { $_->stringify } grep { !$_->is_dir }
        $dir->children( no_hidden => 1 );
    _index( $year, @files );
}

sub _index {
    my( $year, @files ) = @_;

    for my $file ( @files ) {
        next if -d $file;

        unless( $file =~ m{\.zip$}i ) {
            printf "[ERROR] %s is not a zip file\n", $file;
            next;
        }

        printf "Indexing %s\n", $file;

        my $basename = File::Basename::basename( $file );
        if ( $rs->search( { filename => $basename } )->count ) {
            printf
                "[ERROR] A file of the same name (%s) has already been indexed\n",
                $basename;
            next;
        }

        $schema->txn_do( sub {
            my $pack = $rs->new_from_file( $file, $year, $c );
            $pack->update( { approved => 1 } );
        } );
    }
}
