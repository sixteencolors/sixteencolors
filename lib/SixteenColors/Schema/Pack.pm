package SixteenColors::Schema::Pack;

use strict;
use warnings;

use base qw( DBIx::Class );

__PACKAGE__->load_components( qw( TimeStamp Core ) );
__PACKAGE__->table( 'pack' );
__PACKAGE__->add_columns(
    id => {
        data_type         => 'bigint',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    group_id => {
        data_type      => 'bigint',
        is_foreign_key => 1,
        is_nullable    => 1,
    },
    filename => {
        data_type   => 'varchar',
        size        => 512,
        is_nullable => 0,
    },
    file_path => {
        data_type   => 'varchar',
        size        => 512,
        is_nullable => 0,
    },
    year => {
        data_type   => 'integer',
        is_nullable => 1,
    },
    month => {
        data_type   => 'integer',
        is_nullable => 1,
    },
    ctime => {
        data_type     => 'datetime',
        default_value => \'CURRENT_TIMESTAMP',
        set_on_create => 1,
    },
    mtime => {
        data_type     => 'datetime',
        default_value => \'CURRENT_TIMESTAMP',
        set_on_create => 1,
        set_on_update => 1,
    },
);
__PACKAGE__->set_primary_key( qw( id ) );

__PACKAGE__->belongs_to( group => 'SixteenColors::Schema::Group', 'group_id' );
__PACKAGE__->has_many( files => 'SixteenColors::Schema::File', 'pack_id' );


1;
