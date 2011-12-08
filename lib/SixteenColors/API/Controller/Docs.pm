package SixteenColors::API::Controller::Docs;

use Moose;
use namespace::autoclean;

use URI;

BEGIN {
    extends 'Catalyst::Controller';
}

sub auto : Private {
    my ( $self, $c ) = @_;

    $c->stash(
        base_url   => URI->new( 'http://sixteencolors.net' ),
        static_url => $c->uri_for( '/static/' ),
    );

    return 1;
}

sub default : Path {
    my ( $self, $c, @args ) = @_;

    push @args, 'index' if !@args;

    $args[ -1 ] .= '.tt';
    unshift @args, 'api';
    if ( -e $c->path_to( 'root', @args ) ) {
        $c->stash( current_view => 'HTML' );
        $c->stash( template => join( '/', @args ) );
        return;
    }

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

SixteenColors::API::Controller::Docs - Docs Controller for SixteenColors::API

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 default

Attempt to render a view, if needed.

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
