package SixteenColors::Schema::AccountRoleJoin;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components( qw( TimeStamp Core ) );
__PACKAGE__->table( 'account_role_join' );
__PACKAGE__->add_columns(
    account_id => {
        data_type   => 'bigint',
        is_nullable => 0,
    },
    role_id => {
        data_type   => 'bigint',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key( qw( account_id role_id ) );

__PACKAGE__->belongs_to(
    account => 'SixteenColors::Schema::Account',
    'account_id'
);
__PACKAGE__->belongs_to(
    role => 'SixteenColors::Schema::AccountRole',
    'role_id'
);

1;
