package SixteenColors::API::Controller::Root;

use Moose;
use namespace::autoclean;

BEGIN {
    extends 'Catalyst::Controller';
}

__PACKAGE__->config->{ namespace } = '';

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
}

sub default : Path {
    my ( $self, $c, @args ) = @_;

    $c->response->body( 'Page not found' );
    $c->response->status( 404 );
}

sub end : Private {
    my ( $self, $c ) = @_;
    $c->forward( 'render' );
}

sub render : ActionClass('RenderView') {
}

1;

__END__

=head1 NAME

SixteenColors::API::Controller::Root - Root Controller for SixteenColors

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 default

=head2 index

=head2 end

=head2 render

Attempt to render a view, if needed.

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
