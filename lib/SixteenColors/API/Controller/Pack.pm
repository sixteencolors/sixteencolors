package SixteenColors::API::Controller::Pack;

use Moose;
use namespace::autoclean;

BEGIN {
    extends 'SixteenColors::API::Base::Controller';
}

sub base : Chained('/') PathPrefix CaptureArgs(0) { }

sub random : Chained('base') : PathPart('random') : Args(0) {
    my ( $self, $c ) = @_;
    $self->status_ok( $c, entity => scalar $c->model( 'DB::Pack' )->random ); 
}

sub list : Chained('base') PathPart('') Args(0) {
    my ( $self, $c ) = @_;
    $self->status_ok( $c, entity => $c->model( 'DB::Pack' ) );
}

sub instance : Chained('base') PathPart('') CaptureArgs(1) {
    my( $self, $c, $arg ) = @_;

    $c->stash->{ pack } = $c->model( 'DB::Pack' )->find( $arg, { key => 'pack_canonical_name' } );

    if( !$c->stash->{ pack } ) {
        $self->status_not_found( $c, message => 'Invalid Pack' );
        $c->detach;
    }
}

sub view : Chained('instance') PathPart('') Args(0) {
    my ( $self, $c ) = @_;
    $self->status_ok( $c, entity => $c->stash->{ pack } );
}

sub file : Chained('instance') PathPart('') Args(1) {
    my( $self, $c, $arg ) = @_;

    my $file = $c->stash->{ pack }->files( { filename => $arg } )->first;

    if( !$file ) {
        $self->status_not_found( $c, message => 'Invalid File' );
        $c->detach;
    }

    $self->status_ok( $c, entity => $file );
}

1;

__END__

=head1 NAME

SixteenColors::API::Controller::Pack - Pack Controller for SixteenColors

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 list

Attempt to render a view, if needed.

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
