package SixteenColors::View::Feed;

use Moose;
use namespace::autoclean;

extends 'Catalyst::View';

use XML::Atom::SimpleFeed;
use DateTime;

sub process {
    my ( $self, $c ) = @_;

}

1;
