package SixteenColors::Schema::ArtistGroupJoin;

use strict;
use warnings;

use base qw( DBIx::Class );

__PACKAGE__->load_components( qw( TimeStamp Core ) );
__PACKAGE__->table( 'artist_group_join' );
__PACKAGE__->add_columns(
    artist_id => {
        data_type      => 'bigint',
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    group_id => {
        data_type      => 'bigint',
        is_foreign_key => 1,
        is_nullable    => 0,
    },
);
__PACKAGE__->set_primary_key( qw( artist_id group_id ) );
__PACKAGE__->belongs_to( artist => 'SixteenColors::Schema::Artist', 'artist_id' );
__PACKAGE__->belongs_to( group  => 'SixteenColors::Schema::Group',  'group_id' );

1;
