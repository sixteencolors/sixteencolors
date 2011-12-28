package SixteenColors::Schema;

use strict;
use warnings;

use base qw( DBIx::Class::Schema );

__PACKAGE__->load_namespaces;
__PACKAGE__->load_components(qw/+DBIx::Class::Schema::Journal/);

__PACKAGE__->journal_connection(['dbi:SQLite:audit.db']);
__PACKAGE__->journal_user(['My::Schema::Account', {'foreign.userid' => 'self.user_id'}]);

1;
