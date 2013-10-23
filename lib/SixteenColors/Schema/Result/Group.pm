package SixteenColors::Schema::Result::Group;

use strict;
use warnings;

use parent qw( DBIx::Class );

use Text::CleanFragment ();

__PACKAGE__->load_components( qw( TimeStamp Core ) );
__PACKAGE__->table( 'group' );
__PACKAGE__->add_columns(
    id => {
        data_type         => 'bigint',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    name => {
        data_type   => 'varchar',
        size        => 512,
        is_nullable => 0,
    },
    shortname => {
        data_type   => 'varchar',
        size        => 128,
        is_nullable => 0,
    },
    ctime => {
        data_type     => 'timestamp',
        default_value => \'CURRENT_TIMESTAMP',
        set_on_create => 1,
    },
    mtime => {
        data_type     => 'timestamp',
        is_nullable   => 1,
        set_on_create => 1,
        set_on_update => 1,
    },
);
__PACKAGE__->set_primary_key( qw( id ) );
__PACKAGE__->add_unique_constraint( [ 'shortname' ] );

sub store_column {
    my ( $self, $name, $value ) = @_;

    if ( $name eq 'name' && !$self->shortname ) {
        my $fragment = lc Text::CleanFragment::clean_fragment( $value );
        $self->shortname( $fragment );
    }

    $self->next::method( $name, $value );
}

sub TO_JSON {
    my $self = shift;
    return { $self->get_columns };
}

1;
