#!/usr/bin/perl

use strict;
use warnings;

use lib 'lib';

use File::Basename ();
use SixteenColors;

my $c     = 'SixteenColors';
my $year  = shift;
my @files = @ARGV;
my $rs    = $c->model( 'DB::Pack' );

unless( $year and $year  =~ m{^\d\d\d\d$} ) {
    print "[ERROR] Invalid year specified\n";
    exit;
}

for my $file ( @files ) {
    printf "Indexing %s\n", $file;

    my $basename = File::Basename::basename( $file );
    if ( $rs->search( { filename => $basename } )->count ) {
        printf
            "[ERROR] A file of the same name (%s) has already been indexed\n",
            $basename;
        next;
    }

    $rs->new_from_file( $file, $year, $c );
}
