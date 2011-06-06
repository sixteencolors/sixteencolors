package SixteenColors::View::JSON;
use strict;
use warnings;

use base qw( Catalyst::View::JSON );
use JSON::XS ();

__PACKAGE__->config( expose_stash => 'json_data' );

sub encode_json {
    my ( $self, $c, $data ) = @_;
    my $encoder = JSON::XS->new->convert_blessed;
    $encoder->encode( $data );
}

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
