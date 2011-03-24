package SixteenColors::Schema::Result::Group;

use strict;
use warnings;

use base qw( DBIx::Class );

__PACKAGE__->load_components( qw( TimeStamp Core ) );
__PACKAGE__->table( 'art_group' );    # can't just use "group" here.
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
        size        => 25,
        is_nullable => 0,
    },
    history => {
        data_type   => 'text',
        is_nullable => 1,
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

__PACKAGE__->has_many(
    pack_joins => 'SixteenColors::Schema::Result::PackGroupJoin' => 'group_id' );
__PACKAGE__->many_to_many( packs => 'pack_joins' => 'pack' );

__PACKAGE__->has_many(
    artist_joins => 'SixteenColors::Schema::Result::ArtistGroupJoin' => 'group_id' );
__PACKAGE__->many_to_many( artists => 'artist_joins' => 'artist' );

sub store_column {
    my ( $self, $name, $value ) = @_;

    if( $name eq 'name' ) {
        my $short = lc $value;
        $short =~ s{[^a-z0-9]+}{_}g;
        $short =~ s{^_}{};
        $short =~ s{_$}{};
        $self->shortname( $short );
    }

    $self->next::method( $name, $value );
}

1;
