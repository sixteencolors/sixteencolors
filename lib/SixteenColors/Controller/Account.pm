package SixteenColors::Controller::Account;

use Moose;
use namespace::autoclean;

BEGIN {
    extends 'Catalyst::Controller';
}

sub account : Path('/account') Args(0) {
    my ( $self, $c ) = @_;

    $c->stash( title => 'My Account' );

    $c->res->redirect( $c->uri_for( '/' ) )
        unless $c->user_exists;

    if (my $username = $c->req->params->{username}) {

        $c->user->update( { username => $username } );
    }

    if (my $email = $c->req->params->{email}) {

        $c->user->update( { email => $email } );
    }

}

1;

__END__

=head1 NAME

SixteenColors::Controller::Account - Catalyst Controller

=head1 DESCRIPTION

This is the controller class for user configurable account settings.

=head1 METHODS

=head2 account

=head2 ...

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
