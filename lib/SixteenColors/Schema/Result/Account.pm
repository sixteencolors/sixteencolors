package SixteenColors::Schema::Result::Account;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( qw( TimeStamp Core ) );
__PACKAGE__->table( 'account' );
__PACKAGE__->add_columns(
    id => {
        data_type         => 'bigint',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    username => {
        data_type   => 'varchar',
        size        => 100,
        is_nullable => 1,
    },
    name => {
        data_type   => 'varchar',
        size        => 256,
        is_nullable => 1,
    },
    email => {
        data_type   => 'varchar',
        size        => 512,
        is_nullable => 1,
    },
    openid => {
        data_type   => 'text',
        is_nullable => 0,
    },
    rendering => {
        data_type   => 'text',
        is_nullable => 1,
    },
    enabled => {
        data_type     => 'boolean',
        is_nullable   => 1,
        default_value => 1,
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

__PACKAGE__->set_primary_key( 'id' );
__PACKAGE__->has_many(
    account_role_joins => 'SixteenColors::Schema::Result::AccountRoleJoin' =>
        'account_id' );
__PACKAGE__->many_to_many( roles => 'account_role_joins' => 'role' );
__PACKAGE__->add_unique_constraint( [ 'username' ] );

1;
