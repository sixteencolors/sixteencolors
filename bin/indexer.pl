#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Path::Class::Dir ();
use Try::Tiny;
use SixteenColors;

my $schema = SixteenColors->model( 'DB' )->schema;
my $rs = $schema->resultset( 'Pack' );

if( !@ARGV ) {
    print <<"EOUSAGE"
USAGE: $0 /path/to/archive/sorted/by/year/
       $0 /path/to/directory/year/1990/
       $0 year /path/to/directory/
       $0 year /path/to/file.ext
EOUSAGE
}
elsif( -d $ARGV[ 0 ] ) {
    my $dir = Path::Class::Dir->new( shift );

    if( $dir->basename =~ m{^\d{4}$} ) {
        _index_dir( $dir->basename, $dir );
    }
    else {
        my @years = sort map { $_->basename }
            grep { $_->is_dir && $_->basename =~ m{^\d{4}$} }
            $dir->children( no_hidden => 1 );
        _index_dir( $_, $dir->subdir( $_ ) ) for @years;
    }
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
        printf "Indexing %s\n", $file;

        try {
            my $pack = $rs->new_from_file( $c, $file, $year );
            # TODO make this a CLI option. For now assume all CLI parsed packs are OK
            $schema->txn_do( sub { $pack->update( { approved => 1 } ) } );
        }
        catch {
            printf "[ERROR] Problem indexing: %s\n", $_;
        };
    }
}
