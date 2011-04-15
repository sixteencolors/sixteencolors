package SixteenColors::View::JSON;
use strict;
use warnings;

use base qw( Catalyst::View::JSON );
use JSON::XS ();


__PACKAGE__->config(
	expose_stash => 'json_data'
);
sub encode_json {
    my($self, $c, $data) = @_;
    my $encoder = JSON::XS->new->convert_blessed;
    $encoder->encode($data);
}

1;