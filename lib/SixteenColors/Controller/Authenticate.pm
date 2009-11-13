package SixteenColors::Controller::Authenticate;

use strict;
use warnings;

use parent 'Catalyst::Controller';

=head1 NAME

SixteenColors::Controller::Authenticate - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 login 

=cut

sub login : Path('/login') Args(0) {
    my ( $self, $c ) = @_;

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
    if ( my $openid = $c->req->params->{openid} ) {
        $c->authenticate( { openid_identifier => $openid }, 'openid' );
    }
}

=head2 logout

=cut

sub logout : Path('/logout') Args(0) {
    my ( $self, $c ) = @_;
    $c->logout;
    $c->res->redirect( $c->uri_for( '/' ) );
}

=head1 AUTHOR

Brian Cassidy,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
