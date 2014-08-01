package SixteenColors::Schema::ResultSet::Pack;

use strict;
use warnings;

use parent 'DBIx::Class::ResultSet';

sub new_from_file {
    # TODO get $c, so we have an app context
    my ( $self, $file, $year ) = @_;

    die 'here';
}

1;

