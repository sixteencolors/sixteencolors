package SixteenColors::View::Feed;

use Moose;
use namespace::autoclean;
use DateTime;

BEGIN {
    extends 'Catalyst::View';
}

sub process {
    my ( $self, $c ) = @_;

    my $key  = $c->stash->{ serialize_key };
    my $data = $key ? $c->stash->{ $key } : undef;

    if( !$data || !blessed $data || !$data->can( 'TO_FEED' ) ) {
        $c->response->body( 'Page not found' );
        $c->response->status( 404 );
        return;
    }

    my $link  = $c->req->original_uri;
    my $defaults = {
        title   => $c->stash->{ title } || '',
        id      => $link,
        updated => DateTime->now->iso8601 . 'Z',
        author  => { name => 'Sixteen Colors', email => 'contact@sixteencolors.net' },
        link    => { rel => 'self', href => $link },
    };

    my $feed = $data->TO_FEED( $c, $defaults );

    my $output = $feed->as_string;

    if( $c->is_development_server && eval { require XML::Tidy::Tiny } ) {
        $output = XML::Tidy::Tiny::xml_tidy( $output );
    }

    $c->res->content_type( 'application/atom+xml' );
    $c->res->body( $output );
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
