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

    my $packs = $c->model('DB::Pack')->search;
    $c->stash->{ packs } = $packs;
}

sub instance :Chained('/') :PathPrefix :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    
    my $pack = $c->model( 'DB::Pack' )->find( $id, { key => 'pack_canonical_name' } );

    if( !$pack ) {
        $c->res->body( '404 Not Found' );
        $c->res->code( '404' );
        return;
    }

    $c->stash->{ pack } = $pack;
}

sub view :Chained('instance') :PathPart('') :Args(0) {
}


=head1 AUTHOR

Brian Cassidy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
