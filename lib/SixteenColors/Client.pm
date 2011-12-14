package SixteenColors::Client;

use Moose;

BEGIN {
    extends 'Net::HTTP::Spore';
}

around 'new_from_spec' => sub {
    my $orig = shift;
    my $self = shift;

    my $obj = $self->$orig( @_ );

    $obj->enable( 'Format::JSON' );
    return $obj;
};

sub new_from_api_ver {
    my( $class, $v ) = @_;
    return $class->new_from_spec( "http://api.sixteencolors.net/v$v/" );
}

1;
