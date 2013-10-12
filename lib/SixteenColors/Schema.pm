package SixteenColors::Schema;

use strict;
use warnings;

use base qw( DBIx::Class::Schema );

__PACKAGE__->load_namespaces;
__PACKAGE__->load_components( 'Schema::Journal' );

__PACKAGE__->journal_connection( [ 'dbi:mysql:database=sixteencolors_audit', 'root', '0r4ng3' ] );
__PACKAGE__->journal_user( [ 'SixteenColors::Schema::Result::Account', { 'foreign.id' => 'self.user_id' } ]);

1;
