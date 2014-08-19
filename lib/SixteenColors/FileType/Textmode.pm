package SixteenColors::FileType::Textmode;

use strict;
use warnings;

use Image::TextMode::Loader;

use parent 'SixteenColors::FileType';

sub source {
    my $self = shift;
    my $file = $self->filename;
    return Image::TextMode::Loader->load( "$file" )->as_ascii;
}

1;
