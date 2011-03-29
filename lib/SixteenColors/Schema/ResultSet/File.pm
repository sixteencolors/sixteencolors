package SixteenColors::Schema::ResultSet::File;

use strict;
use warnings;

use SixteenColors::Archive;
use Image::TextMode::SAUCE;
use Try::Tiny;

use base 'DBIx::Class::ResultSet::Data::Pageset';

sub random {
    my $self = shift;   
    $self->search( { }, { rows => 5, order_by => 'RANDOM()' } );
}

1;
