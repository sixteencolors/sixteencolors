package SixteenColors::Controller::Authenticate;

use Moose;
use namespace::autoclean;

BEGIN {
    extends 'Catalyst::Controller';
}

sub login : Path('/login') Args(0) {
    my ( $self, $c ) = @_;

    $c->stash( title => 'Login' );

    # we've returned from the OpenID Provider
    if ( $c->req->params->{ 'openid-check' } ) {
        if ( eval { $c->authenticate( {}, 'openid' ); } ) {
            $c->res->redirect( $c->uri_for( '/' ) );
            return;
        }

        die 'OpenID verification failed.';
    }

    return unless lc $c->request->method eq 'post';

    # forward the request on to the OpenID provider
    if ( my $openid = $c->req->params->{ openid } ) {
        $c->authenticate( { openid_identifier => $openid }, 'openid' );
    }
}

sub logout : Path('/logout') Args(0) {
    my ( $self, $c ) = @_;
    $c->logout;
    $c->res->redirect( $c->uri_for( '/' ) );
}

1;

__END__

=head1 NAME

SixteenColors::Controller::Authenticate - Catalyst Controller

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 login

=head2 logout

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
