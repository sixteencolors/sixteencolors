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

    my $page = $c->req->params->{ page } || 1;
    my $results_per_page = 20; # Google will not return more than 20 per page
    my $start = ($page - 1) * $results_per_page;
    my $uri = URI->new( 'http://www.google.com/search' );
    $uri->query_form ( {
        q      => $c->req->params->{ q },
        hl     => 'en',
        start  => $start,
        num    => $results_per_page,
        output => 'xml',
        client => 'google-csbe',
        cx     => $self->api_key
    } );

    my $xml = LWP::Simple::get( $uri );

    my $xs = XML::Simple->new( ForceArray => [ 'R' ] );
    my $doc = $xs->XMLin($xml);

    my $pageset;

    if( exists $doc->{ RES } ) {
        $pageset = Data::Pageset->new({
            'total_entries' => $doc->{RES}->{M},
            'entries_per_page' => $doc->{PARAM}->{num}->{value},
            'current_page' => $page
        });
    }

    $c->stash(
        pager => $pageset,
        template => 'search/results.tt',
        files => $doc->{RES}->{R},
        uri => $uri,
        next => $doc->{RES}->{NB}->{NU},
        prev => $doc->{RES}->{NB}->{PU}
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
