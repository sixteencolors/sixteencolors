#!/usr/bin/perl

use strict;
use warnings;

use lib 'lib';

use SixteenColors;

my $c     = 'SixteenColors';
my @files = @ARGV;
my $rs    = $c->model( 'DB::Pack' );

for my $file ( @files ) {
    print "Indexing ${file}\n";
    $rs->new_from_file( $file, $c );
}
