package SixteenColors::API::Controller::File;

use Moose;
use namespace::autoclean;

BEGIN {
    extends 'SixteenColors::API::Base::Controller';
}

sub base : Chained('/') PathPrefix CaptureArgs(0) { }

sub random : Chained('base') : PathPart('random') : Args(0) {
    my ( $self, $c ) = @_;
    $self->status_ok( $c, entity, $c->model( 'DB::File' )->random ); 
}

1;

__END__

=head1 NAME

SixteenColors::API::Controller::File - File Controller for SixteenColors

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
