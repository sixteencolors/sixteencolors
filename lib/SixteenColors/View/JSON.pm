package SixteenColors::View::JSON;
use base qw( Catalyst::View::JSON );
use JSON::XS ();

sub encode_json {
    my($self, $c, $data) = @_;
    my $encoder = JSON::XS->new->convert_blessed;
    $encoder->encode($data);
}

1;