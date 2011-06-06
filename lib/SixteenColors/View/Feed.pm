package SixteenColors::View::Feed;

use Moose;
use namespace::autoclean;
use XML::Atom::SimpleFeed;
use DateTime;

BEGIN {
    extends 'Catalyst::View';
}

sub process {
    my ( $self, $c ) = @_;

    my $data = $c->stash->{ for_serialization };

    if( !$data ) {
        $c->response->body( 'Page not found' );
        $c->response->status( 404 );
        return;
    }

    my $feed = XML::Atom::SimpleFeed->new(
    );

    $c->res->content_type( 'application/atom+xml' );
    $c->res->body( $feed->as_string );
}

1;

__END__

=head1 NAME

SixteenColors::View::Feed - Feed view for SixteenColors

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 process

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
