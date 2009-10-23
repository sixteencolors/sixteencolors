package SixteenColors::Archive;

use strict;
use warnings;

use SixteenColors::Archive::ZIP;
use SixteenColors::Archive::RAR;
use SixteenColors::Archive::ARJ;

our $VERSION = '0.01';

my %types = (
    rar => 1,
    zip => 1,
    arj => 1,
);

sub new {
    my $class = shift;
    my $options = shift || {};

    my $file = $options->{ file };

    die 'No file specified!' unless defined $file;
    die 'File does not exist!' unless -e $file;

     my( $ext ) = $file =~ m{([^.]+)$};

    die 'Extension not supported!' unless $types{ lc $ext };

    my $archive_class = 'SixteenColors::Archive::' . uc( $ext );
   
    return $archive_class->new( { file => $file } );
}

1;
