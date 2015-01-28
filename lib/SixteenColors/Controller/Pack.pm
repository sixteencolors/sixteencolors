package SixteenColors::Controller::Pack;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use SixteenColors::Form::Pack;

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched SixteenColors::Controller::Pack in Pack.');
}

sub instance : Chained('/') : PathPrefix : CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    my $pack = $c->model( 'DB::Pack' )
        ->find( $id, { key => 'pack_shortname' } );

    if ( !$pack ) {
        $c->res->body( '404 Not Found' );
        $c->res->code( '404' );
        $c->detach;
    }

    $c->stash->{ pack } = $pack;
    $c->stash->{ root } = $pack->get_root_file;
}

sub view : Chained('instance') : PathPart('') : Args(0) {
    my ( $self, $c ) = @_;

    my $form = SixteenColors::Form::Pack->new;
    $c->stash->{ form } = $form;

    if( $form->process(
        item_id => $c->stash->{ pack }->id,
        params  => $c->req->parameters,
        schema  => $c->model( 'DB' )->schema
    ) ) {
        $c->stash->{ pack }->discard_changes;
    }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

SixteenColors::Controller::Pack - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 index

=head2 instance

=encoding utf8

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
