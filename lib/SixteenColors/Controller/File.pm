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


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched SixteenColors::Controller::File in File.');
}

sub instance : Chained('/pack/instance') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    my $file = $c->stash->{ pack }->files( { filename => $id } )->first;

    if( !$file ) {
        $c->res->body( '404 Not Found' );
        $c->res->code( '404' );
        return;
    }

    $c->stash->{ file } = $file;
}

sub view : Chained('instance') :PathPart('') :Args(0) {
}

sub preview : Chained('instance') :PathPart('preview') :Args(0) {
    my( $self, $c ) = @_;

    my $file = $c->stash->{ file };
    my $pack = $c->stash->{ pack };

    if( !$file->is_bitmap && $file->is_not_textmode ) {
        my $type = $file->is_audio ? 'audio' : 'binary';
        $c->res->redirect( $c->uri_for( "/static/images/${type}-preview.png" ) );
        return;
    }

    my $url  = join( '/', '/static/tn', $pack->canonical_name, $file->filename . '.png' );
    my $path = $c->path_to( "/root${url}" );
    $file->generate_thumbnail( $path ) unless -e $path;
    $c->res->redirect( $c->uri_for( $url ) );
}

sub fullscale : Chained('instance') :PathPart('fullscale') :Args(0) {
    my( $self, $c ) = @_;

    my $file = $c->stash->{ file };
    my $pack = $c->stash->{ pack };

    my $url  = join( '/', '/static/fs', $pack->canonical_name, $file->filename . ( $file->is_bitmap ? '.png' : '' ) );
    my $path = $c->path_to( "/root${url}" );
    $file->generate_fullscale( $path ) unless -e $path;
    $c->res->redirect( $c->uri_for( $url ) );
}

sub download :Chained('instance') :PathPart('download') :Args(0) {
    my ( $self, $c ) = @_;
    my $file = $c->stash->{ file };
    my $pack = $c->stash->{ pack };

    $c->res->header( 'Content-Disposition' => 'attachment; filename=' . File::Basename::basename( $file->file_path ) );
    $c->res->body( $file->slurp );
}

=head1 AUTHOR

Brian Cassidy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
