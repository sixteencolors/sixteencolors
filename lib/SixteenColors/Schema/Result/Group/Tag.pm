package SixteenColors::Schema::Result::Group::Tag;

use strict;
use warnings;

use parent qw( DBIx::Class );

__PACKAGE__->load_components( qw( TimeStamp Core ) );
__PACKAGE__->table( 'group_tag' );
__PACKAGE__->add_columns(
    group_id => {
        data_type      => 'bigint',
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    tag => {
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
__PACKAGE__->set_primary_key( qw( group_id tag ) );

__PACKAGE__->belongs_to(
    group => 'SixteenColors::Schema::Result::Group',
    'group_id'
);

1;
