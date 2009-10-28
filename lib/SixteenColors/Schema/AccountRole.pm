package SixteenColors::Schema::AccountRole;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( qw( TimeStamp Core ) );
__PACKAGE__->table( 'account_role' );
__PACKAGE__->add_columns(
    id => {
        data_type         => 'bigint',
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    name => {
        data_type   => 'varchar',
        size        => 100,
        is_nullable => 0,
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

__PACKAGE__->set_primary_key( 'id' );

__PACKAGE__->has_many(
    account_role_joins => 'SixteenColors::Schema::AccountRoleJoin' =>
        'role_id' );
__PACKAGE__->many_to_many( accounts => 'account_role_joins' => 'account' );

1;
