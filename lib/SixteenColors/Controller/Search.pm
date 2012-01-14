package SixteenColors::Controller::Search;

use Moose;
use namespace::autoclean;
use URI;
use LWP::Simple;
use XML::Simple;
use Data::Dumper;

BEGIN {
    extends 'Catalyst::Controller';
}

sub index : Path : Args(0) {
    # 006684255443611537751:qjvj1fyr2ui Google API Key

    # http://www.google.com/search?q=maestro&hl=en&start=10&num=10&output=xml&client=google-csbe&cx=006684255443611537751:qjvj1fyr2ui 


    my ( $self, $c ) = @_;
    $c->stash( title => 'Search' );

    my $key = "006684255443611537751:qjvj1fyr2ui";
    my $page = $c->req->params->{ page } || 1;
    my $results_per_page = 20; # Google will not return more than 20 per page
    my $start = ($page - 1) * $results_per_page;
    my $uri = URI->new("http://www.google.com/search?q=" . $c->req->params->{ q } . "&hl=en&start=" . $start . "&num=" . $results_per_page . "&output=xml&client=google-csbe&cx=" . $key);
    my $xml = get $uri;

    my $xs = XML::Simple->new();
    my $doc = $xs->XMLin($xml);

    my $pageset = Data::Pageset->new({
        'total_entries' => $doc->{RES}->{M},
        'entries_per_page' => $doc->{PARAM}->{num}->{value},
        'current_page' => $page
    });

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
