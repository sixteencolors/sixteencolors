package Catalyst::Action::Serialize::SixteenColors::API::JSON;

use Moose;
use namespace::autoclean;

extends 'Catalyst::Action::Serialize::JSON';

before 'execute' => sub {
    my $self = shift;
    my ( $controller, $c ) = @_;

    if ( my $options = $controller->config->{ json_options } ) {
        foreach my $opt ( keys %$options ) {
            $self->encoder->$opt( $options->{ $opt } );
        }
    }
};

after 'execute' => sub {
    my $self = shift;
    my ($controller, $c) = @_;

    # Ripped from Catalyst::Action::Serialize::JSONP

    my $callback_key = (
        $controller->{ serialize } ?
            $controller->{ serialize }->{ callback_key } :
            $controller->{ callback_key }
    ) || 'callback';

    my $callback_value = $c->req->param( $callback_key );
    if ( $callback_value ) {
        if ($callback_value =~ /^\w+$/ ) {
            $c->res->content_type( 'text/javascript' );
            $c->res->output( $callback_value . '(' . $c->res->output() . ');' );
        }
        else {
            warn 'Callback: '.$callback_value.' will not generate valid Javascript. Falling back to JSON output';
        }
    }
};

1;
