package SixteenColors::API::Controller::Artist;

use Moose;
use namespace::autoclean;

BEGIN {
    extends 'SixteenColors::API::Base::Controller';
}

sub base : Chained('/') PathPrefix CaptureArgs(0) { }

sub list : Chained('base') PathPart('') Args(0) {
    my ( $self, $c ) = @_;
    $self->status_ok( $c, entity => scalar $c->model( 'DB::Artist' )->search( {}, { order_by => 'name' } ) );
}

sub instance : Chained('base') PathPart('') CaptureArgs(1) {
    my( $self, $c, $arg ) = @_;

    $c->stash->{ artist } = $c->model( 'DB::Artist' )->find( $arg, { key => 'artist_shortname' } );

    if( !$c->stash->{ artist } ) {
        $self->status_not_found( $c, message => 'Invalid Artist' );
        $c->detach;
    }
}

sub view : Chained('instance') PathPart('') Args(0) {
    my ( $self, $c ) = @_;
    $self->status_ok( $c, entity => $c->stash->{ artist } );
}

1;

__END__

=head1 NAME

SixteenColors::API::Controller::Artist - Artist Controller for SixteenColors

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
