package SixteenColors::Schema::ResultSet::Artist;

use strict;
use warnings;

use base 'DBIx::Class::ResultSet::Data::Pageset';

sub TO_JSON {
    my $self = shift;
    return [
        map { { $_->get_columns } } $self->all
    ]
}

1;
