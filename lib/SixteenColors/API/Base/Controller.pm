package SixteenColors::API::Base::Controller;

use Moose;
use namespace::autoclean;

BEGIN {
    extends 'Catalyst::Controller::REST';
}

__PACKAGE__->config(
    content_type_stash_key => 'content_type'
);

sub begin : Private {
    my ( $self, $c ) = @_;
    $c->stash->{ content_type } = 'application/json';
    $c->forward( 'deserialize' );
}

sub deserialize : ActionClass('Deserialize') {}

sub end : Private {
    my( $self, $c ) = @_;
    $c->forward( 'serialize' );
    $c->res->content_type( $c->res->content_type . '; charset=utf-8' );
}

sub serialize : ActionClass('Serialize') {}

1;
