package SixteenColors::Schema::ResultSet::File;

use strict;
use warnings;
use SixteenColors::FileTypes;

use parent 'DBIx::Class::ResultSet';

sub artworks {
    my ( $self ) = @_;
    my $types = SixteenColors::FileTypes->new;
    return $self->search( { type => [ $types->artwork_types ] } );
}

1;

