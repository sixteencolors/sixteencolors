package SixteenColors::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';

__PACKAGE__->config->{ namespace } = '';

=head1 NAME

SixteenColors::Controller::Root - Root Controller for SixteenColors

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

sub auto : Private {
    my( $self, $c ) = @_;

    $c->stash(
        base_url   => $c->uri_for( '/' ),
        static_url => $c->uri_for( '/static/' ),
    );

    return 1;
}

=head2 index

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    my $feeds = $c->model( 'Feeds' );

    $c->stash(
        tweet => $feeds->latest_tweets( 1 )->[ 0 ],
        news  => $feeds->latest_news( 2 ),
        packs => [ $c->model( 'DB::Pack' )->recent->search( {}, { rows => 4 } ) ],
        works => [ $c->model( 'DB::File' )->random->search( {}, { rows => 4 } ) ],
    );
}

sub default : Path {
    my ( $self, $c, @args ) = @_;

    $args[ -1 ] .= '.tt';
    unshift @args, 'pages';
    if ( -e $c->path_to( 'root', @args ) ) {
        $c->stash( template => join( '/', @args ) );
        return;
    }

    $c->response->body( 'Page not found' );
    $c->response->status( 404 );
}

sub render : ActionClass('RenderView') {
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : Private {
    my ( $self, $c ) = @_;

    $c->forward( 'render' );

    $c->fillform if $c->stash->{ fillform };
}

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
