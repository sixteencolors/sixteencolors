package SixteenColors::Schema::FileArtistJoin;

use strict;
use warnings;

use base qw( DBIx::Class );

__PACKAGE__->load_components( qw( TimeStamp Core ) );
__PACKAGE__->table( 'file_artist_join' );
__PACKAGE__->add_columns(
    file_id => {
        data_type      => 'bigint',
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    artist_id => {
        data_type      => 'bigint',
        is_foreign_key => 1,
        is_nullable    => 0,
    },
);
__PACKAGE__->set_primary_key( qw( file_id artist_id ) );
__PACKAGE__->belongs_to( file  => 'SixteenColors::Schema::File',  'file_id' );
__PACKAGE__->belongs_to( artist => 'SixteenColors::Schema::Artist', 'artist_id' );

1;
