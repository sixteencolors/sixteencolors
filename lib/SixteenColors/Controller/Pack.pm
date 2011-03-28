package SixteenColors::Controller::Pack;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

SixteenColors::Controller::Pack - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $packs = $c->model('DB::Pack')->search( {}, { order_by => 'year DESC, month DESC, canonical_name' } );
    my @years  = grep { defined } $packs->get_column( 'year' )->func( 'DISTINCT' );
    my $year = $c->req->params->{ year } || $years[ 0 ];

    $packs = $packs->search( { year => $year }, { rows => 25,  page => $c->req->params->{ page } || 1 } );

    $c->stash( packs => $packs, pager => $packs->pageset, title => 'Packs', years => \@years, current_year => $year );
}

sub instance :Chained('/') :PathPrefix :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    
    my $pack = $c->model( 'DB::Pack' )->find( $id, { key => 'pack_canonical_name' } );

    if( !$pack ) {
        $c->res->body( '404 Not Found' );
        $c->res->code( '404' );
        $c->detach;
    }

    $c->stash->{ pack } = $pack;
}

sub view :Chained('instance') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( title => $c->stash->{ pack }->canonical_name );
}

sub preview :Chained('instance') :PathPart('preview') :Args(0) {
    my ( $self, $c ) = @_;

    my $pack   = $c->stash->{ pack };
    my $base   = '/static/images/p/';
    my $static = $base . $pack->canonical_name . ( exists $c->req->params->{ 's' } ? '-s.png' : '.png' );
    my $path   = $c->path_to( "/root${static}" );

    $pack->generate_preview( $c->path_to( "/root${base}" ) ) unless -e $path;
    $c->res->redirect( $c->uri_for( $static ) );
}

sub download :Chained('instance') :PathPart('download') :Args(0) {
    my ( $self, $c ) = @_;
    my $pack = $c->stash->{ pack };
    my $path = $pack->file_path;
    $c->res->header( 'Content-Disposition' => 'attachment; filename=' . $pack->filename );
    $c->serve_static_file( $path );
}

=head1 AUTHOR

Brian Cassidy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
