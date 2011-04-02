package SixteenColors::Controller::Year;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

SixteenColors::Controller::Year - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    my @years = grep { defined }
        $c->model( 'DB::Pack' )->get_column( 'year' )->func( 'DISTINCT' );

    $c->stash( years => \@years, title => 'Years' );
}

sub view : Path : Args(1) {
    my ( $self, $c, $year ) = @_;

    my $packs = $c->model( 'DB::Pack' )->search( { year => $year } );
    $c->stash( title => $year, packs => $packs );
}

=head1 AUTHOR

Brian Cassidy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
