package SixteenColors::Controller::Root;

use Moose;
use namespace::autoclean;

BEGIN {
    extends 'Catalyst::Controller';
}

__PACKAGE__->config->{ namespace } = '';

sub auto : Private {
    my ( $self, $c ) = @_;

    $c->stash(
        base_url   => $c->uri_for( '/' ),
        static_url => $c->uri_for( '/static/' ),
    );

    return 1;
}

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    my $feeds = $c->model( 'Feeds' );

    $c->stash(
        tweet => $feeds->latest_tweets( 1 )->[ 0 ],
        news  => $feeds->latest_news( 2 ),
        packs =>
            [ $c->model( 'DB::Pack' )->recent->search( {}, { rows => 4 } ) ],
        works =>
            [ $c->model( 'DB::File' )->random->search( {}, { rows => 4 } ) ],
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

sub end : Private {
    my ( $self, $c ) = @_;
    $c->forward( 'render' );
}

sub render : ActionClass('RenderView') {
}

1;

__END__

=head1 NAME

SixteenColors::Controller::Root - Root Controller for SixteenColors

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 auto

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
