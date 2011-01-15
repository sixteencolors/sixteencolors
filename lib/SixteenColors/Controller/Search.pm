package SixteenColors::Controller::Search;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

SixteenColors::Controller::Search - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( title => 'Search' );

    my $q =$c->req->params->{ q };
    return unless $q;

    $c->stash(
        files => $c->model( 'DB::File' )->search_rs(
            { 'file_fulltext.fulltext' => { like => "%${q}%" } },
            { join => 'file_fulltext', page => $c->req->params->{ p } || 1, rows => 10 }
        ),
        groups => $c->model( 'DB::Group' )->search_rs(
            { -or => { name => { like => "%${q}%" }, shortname => { like => "%${q}%" } } }
        ),
        artists => $c->model( 'DB::Artist' )->search_rs(
            { -or => { name => { like => "%${q}%" }, shortname => { like => "%${q}%" } } }
        ),
        template => 'search/results.tt'
    );
}


=head1 AUTHOR

Brian Cassidy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
