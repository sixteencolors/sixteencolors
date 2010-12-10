package SixteenColors::Schema::PackGroupJoin;

use strict;
use warnings;

use base qw( DBIx::Class );

__PACKAGE__->load_components( qw( TimeStamp Core ) );
__PACKAGE__->table( 'pack_group_join' );
__PACKAGE__->add_columns(
    pack_id => {
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
__PACKAGE__->set_primary_key( qw( pack_id group_id ) );
__PACKAGE__->belongs_to( pack  => 'SixteenColors::Schema::Pack',  'pack_id' );
__PACKAGE__->belongs_to( art_group => 'SixteenColors::Schema::Group', 'group_id' );

1;
