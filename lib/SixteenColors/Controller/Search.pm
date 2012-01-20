package SixteenColors::Controller::Search;

use Moose;
use namespace::autoclean;
use URI;
use LWP::Simple ();
use XML::Simple;
use Data::Dumper;

BEGIN {
    extends 'Catalyst::Controller';
}

has 'api_key' => ( isa => 'Str', is => 'ro' );

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( title => 'Search' );

    my $res = $c->model( 'Search' )->search( $c->req->params->{ q } );

    unless( $res->{ http }->is_success ) {
        $c->stash( template => 'search/failure.tt' );
        return;
    }

    $c->stash(
        template => 'search/results.tt',
        pager    => $res->{ pager },
        files    => $res->{ data }->{ RES }->{ R },
    );
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

SixteenColors::Controller::Search - Catalyst Controller

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
