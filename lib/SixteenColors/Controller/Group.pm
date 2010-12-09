package SixteenColors::Controller::Group;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

SixteenColors::Controller::Group - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $groups = $c->model( 'DB::Group' );

    $c->stash( groups => $groups );
}

sub instance :Chained('/') :PathPrefix :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    
    my $group = $c->model( 'DB::Group' )->find( $id, { key => 'art_group_shortname' } );

    if( !$group ) {
        $c->res->body( '404 Not Found' );
        $c->res->code( '404' );
        return;
    }

    $c->stash->{ group } = $group;
}

sub view :Chained('instance') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( title => $c->stash->{ group }->name );
}

=head1 AUTHOR

Brian Cassidy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
