package SixteenColors::Controller::Pack;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

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

    $c->stash( pack => $pack, root => $pack->get_root_file );
}

sub view : Chained('instance') : PathPart('') : Args(0) {
    my ( $self, $c ) = @_;
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
