package SixteenColors::FileType;

use strict;
use warnings;

use Image::TextMode::SAUCE;

sub new {
    my $class = shift;
    return bless { filename => shift }, $class;
}

sub filename {
    my $self = shift;
    return $self->{ filename };
}

sub get_type {
    my $self = shift;
    my( $type ) = ref( $self ) =~ m{\::([a-z]+)$}i;
    return lc $type;
}

sub get_sauce {
    my $self = shift;
    my $sauce = Image::TextMode::SAUCE->new;

    open( my $fh, '<', $self->filename );
    $sauce->read( $fh );
    close( $fh );

    return $sauce;
}

1;
