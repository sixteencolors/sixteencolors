package SixteenColors::FileType::Textmode;

use strict;
use warnings;

use Image::TextMode::Loader;

use parent 'SixteenColors::FileType';

sub get_source {
    my $self = shift;
    my $file = $self->filename;
    return Image::TextMode::Loader->load( "$file" )->as_ascii;
}

sub generate_surrogates {
    my( $self, $c ) = @_;
}

1;
