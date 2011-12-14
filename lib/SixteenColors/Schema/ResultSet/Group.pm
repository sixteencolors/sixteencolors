package SixteenColors::Schema::ResultSet::Group;

use strict;
use warnings;

use base 'DBIx::Class::ResultSet';

sub TO_JSON {
    my $self = shift;
    return [
        map { { $_->get_columns } } $self->all
    ]
}

1;
