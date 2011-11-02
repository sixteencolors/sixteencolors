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

1;
