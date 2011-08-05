package SixteenColors::Controller::Search;

use Moose;
use namespace::autoclean;

BEGIN {
    extends 'Catalyst::Controller';
}

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash( title => 'Search' );

    my $q = $c->req->params->{ q };
    return unless $q;
	
	my $wildcard_search = $q =~ m{\*} ? 1 : 0;

	if ($wildcard_search) {
		$q =~ s/\*/%/g;
	}
	
    my $files = $c->model( 'DB::File' )->search_rs(
        !$wildcard_search ? (
			{   -or => [
                'file_fulltext.fulltext' => { like => "%${q}%" },
                'sauce'                  => { like => "%${q}%" },
                'filename'               => { like => "%${q}%" }
            ]
        }) : (
			{
				'filename' => { like => $q}
			}
		),
        {   join => 'file_fulltext',
            page => $c->req->params->{ page } || 1,
            rows => 25
        }
    );
    $c->stash(
        files  => $files,
        pager  => $files->pageset,
        groups => $c->model( 'DB::Group' )->search_rs(
            {   -or => {
                    name      => { like => "%${q}%" },
                    shortname => { like => "%${q}%" }
                }
            }
        ),
        artists => $c->model( 'DB::Artist' )->search_rs(
            {   -or => {
                    name      => { like => "%${q}%" },
                    shortname => { like => "%${q}%" }
                }
            }
        ),
        template => 'search/results.tt'
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
