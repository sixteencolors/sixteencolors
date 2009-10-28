package SixteenColors::Authentication::Realm::OpenID;

use strict;
use warnings;

use parent 'Catalyst::Authentication::Realm';

sub new {
    my ( $class, $name, $config ) = ( shift, shift, shift );

    $config->{ auto_create_user } = 1;

    return $class->SUPER::new( $name, $config, @_ );
}

sub find_user {
    my ( $self, $authinfo, $c ) = @_;

    $authinfo->{ enabled } = 1;
    $authinfo->{ openid }  = $authinfo->{ url };

    return $self->SUPER::find_user( $authinfo, $c );
}

1;
