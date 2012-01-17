#!/usr/bin/perl

use strict;
use warnings;

use lib 'lib';

use SixteenColors;

my $BASE_URL = 'http://' . ( shift || 'sixteencolors.net' );
my %MAPS  = (
    dynamic => [ qw( artist group file pack ) ],
    static  => [ qw( pages ) ],
);
    
my $LIMIT = 25_000;
$Template::Directive::WHILE_MAX = $LIMIT + 2;

my $c     = 'SixteenColors';
my $view  = $c->view( 'HTML' );
my $path  = $c->path_to( 'root/static' )->subdir( 'sitemap' );
$path->mkpath;
my %pages = ( static => [], dynamic => {} );

# DYNAMIC
for ( @{ ${ MAPS }{ dynamic } } ) {
    my $rs = $c->model( 'DB::' . ucfirst( $_ ) )->search( {}, { page => 1, rows => $LIMIT } );
    my $pager = $rs->pager;
    $pages{ dynamic }->{ $_ } = $pager->last_page;
    my $line = sprintf( "\r[INFO] ${_}s (%%d/%d)", $pager->last_page );

    for my $page ( 1..$pager->last_page ) {
        printf STDERR $line, $page;
        my $items = $rs->page( $page );
        my $file = $path->file( "${_}${page}.xml" );
        my $fh = $file->openw;
        print $fh $view->render( undef, "sitemap/${_}.tt", { base_url => $BASE_URL, no_wrapper => 1, items => $items } );
        close $fh;
    }
    print "\n";
}

# STATIC
for ( @{ ${ MAPS }{ static } } ) {
    print STDERR "\r[INFO] ${_}";
    push @{ $pages{ static } }, $_;
    my $file = $path->file( "${_}.xml" );
    my $fh = $file->openw;
    print $fh $view->render( undef, "sitemap/${_}.tt", { base_url => $BASE_URL, no_wrapper => 1 } );
    close $fh;
    print "\n";
}

# INDEX
print STDERR "\r[INFO] index";
my $file = $path->file( "index.xml" );
my $fh = $file->openw;
print $fh $view->render( undef, "sitemap/index.tt", { base_url => $BASE_URL, no_wrapper => 1, pages => \%pages } );
close $fh;
print "\n";
