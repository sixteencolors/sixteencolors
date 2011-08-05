package SixteenColors::Controller::File;

use strict;
use warnings;
use parent 'Catalyst::Controller';

use File::Basename ();

=head1 NAME

SixteenColors::Controller::File - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub instance : Chained('/pack/instance') : PathPart('') : CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    my $file = $c->stash->{ pack }->files( { filename => $id } )->first;

    if ( !$file ) {
        $c->res->body( '404 Not Found' );
        $c->res->code( '404' );
        $c->detach;
    }

    $c->stash->{ file } = $file;

}

sub view : Chained('instance') : PathPart('') : Args(0) {
    my ( $self, $c ) = @_;
    if ( $c->stash->{ is_api_call } ) {
        $c->stash( json_data => { file => $c->stash->{ file } } );
    }
    $c->stash( fillform => 1, title => $c->stash->{ file }->filename );
}

sub preview : Chained('instance') : PathPart('preview') : Args(0) {
    my ( $self, $c ) = @_;

    my $file = $c->stash->{ file };
    my $pack = $c->stash->{ pack };

    if ( !$file->is_artwork ) {
        my $type = $file->is_audio ? 'audio' : 'binary';
        $c->res->redirect(
            $c->uri_for( "/static/images/${type}-preview.png" ) );
        return;
    }

    # user-options
    my $params = $c->req->params;
    my %options = map { $_ => $params->{ $_ } }
        grep { defined $params->{ $_ } && length $params->{ $_ } }
        keys %$params;

    if ( $c->user_exists && keys %options ) {
        my $tmp = $file->generate_thumbnail( undef, \%options );
        $c->serve_static_file( $tmp );
        return;
    }

    my $fn   = $file->filename . '.png';
    my $url  = join( '/', '/static/images/t', $pack->canonical_name );
    my $path = $c->path_to( "/root${url}/$fn" );
    $file->generate_thumbnail( $path ) unless -e $path;
    $c->res->redirect( $c->uri_for( $url, $fn ) );
}

sub fullscale : Chained('instance') : PathPart('fullscale') : Args(0) {
    my ( $self, $c ) = @_;

    my $file = $c->stash->{ file };
    my $pack = $c->stash->{ pack };

    if ( !$file->is_artwork ) {
        my $type = $file->is_audio ? 'audio' : 'binary';
        $c->res->redirect(
            $c->uri_for( "/static/images/${type}-preview.png" ) );
        return;
    }

    # user-options
    my $params = $c->req->params;
    my %options = map { $_ => $params->{ $_ } }
        grep { defined $params->{ $_ } && length $params->{ $_ } }
        keys %$params;

    if ( $c->user_exists && keys %options ) {
        my $tmp = $file->generate_fullscale( undef, \%options );
        $c->serve_static_file( $tmp );
        return;
    }

    my $fn = $file->filename . ( $file->is_bitmap ? '' : '.png' );
    my $url = join( '/', '/static/images/f', $pack->canonical_name );
    my $path = $c->path_to( "/root${url}/$fn" );
    $file->generate_fullscale( $path ) unless -e $path;
    $c->res->redirect( $c->uri_for( $url, $fn ) );
}

sub download : Chained('instance') : PathPart('download') : Args(0) {
    my ( $self, $c ) = @_;
    my $file = $c->stash->{ file };
    my $pack = $c->stash->{ pack };

    $c->res->header( 'Content-Disposition' => 'attachment; filename='
            . File::Basename::basename( $file->file_path ) );
    $c->res->body( $file->slurp );
}

=head1 AUTHOR

Brian Cassidy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
