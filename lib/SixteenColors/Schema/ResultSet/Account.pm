package SixteenColors::Schema::ResultSet::Account;

use strict;
use warnings;

use base 'DBIx::Class::ResultSet';

sub auto_create {
    my ( $self, $authinfo ) = @_;
    my %cond = ( openid => $authinfo->{ openid } );
    my $account = $self->single( \%cond );

    # the account actually exists, it must be disabled
    die 'Disabled' if $account;

    return $self->create( \%cond );
}

1;
