package SixteenColors::Schema::File;

use strict;
use warnings;

use base qw( DBIx::Class );
use JSON::XS ();

__PACKAGE__->load_components( qw( InflateColumn TimeStamp Core ) );
__PACKAGE__->table( 'file' );
__PACKAGE__->add_columns(
    id => {
        data_type         => 'bigint',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    pack_id => {
        data_type      => 'bigint',
        is_foreign_key => 1,
        is_nullable    => 0,
    },
    artist_id => {
        data_type      => 'bigint',
        is_foreign_key => 1,
        is_nullable    => 1,
    },
    filename => {
        data_type   => 'varchar',
        size        => 512,
        is_nullable => 0,
    },
    title => {
        data_type   => 'varchar',
        size        => 80,
        is_nullable => 1,
    },
    type => {
        data_type   => 'varchar',
        size        => 80,
        is_nullable => 1,
    },
    sauce => {
        data_type   => 'text',
        is_nullable => 1,
    },
    render_options => {
        data_type     => 'varchar',
        default_value => '{}',
        size          => 80,
        is_nullable   => 0,
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
__PACKAGE__->add_unique_constraint( [ 'pack_id', 'filename' ] );

__PACKAGE__->belongs_to( pack => 'SixteenColors::Schema::Pack', 'pack_id' );
__PACKAGE__->belongs_to(
    artist => 'SixteenColors::Schema::Artist',
    'artist_id'
);

__PACKAGE__->inflate_column(
    'render_options',
    {   inflate => sub { JSON::XS::decode_json shift },
        deflate => sub { JSON::XS::encode_json shift },
    }
);

1;
