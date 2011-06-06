package SixteenColors::View::JSON;

use Moose;
use namespace::autoclean;
use JSON::XS ();

BEGIN {
    extends 'Catalyst::View::JSON';
}

__PACKAGE__->config( expose_stash => 'json_data' );

sub process {
    my( $self, $c ) = @_;

    my $data = $c->stash->{ $self->expose_stash };

    if( !$data ) {
        $c->response->body( 'Page not found' );
        $c->response->status( 404 );
        return;
    }

    return $self->next::method( $c );
}

sub encode_json {
    my ( $self, $c, $data ) = @_;
    my $encoder = JSON::XS->new->convert_blessed;

    $encoder = $encoder->pretty if $c->is_development_server;

    $encoder->encode( $data );
}

1;

__END__

=head1 NAME

SixteenColors::View::JSON - JSON view for SixteenColors

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 encode_json

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
