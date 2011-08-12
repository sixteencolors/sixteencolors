package SixteenColors::API;

use Moose;
use namespace::autoclean;

use 5.10.0;
use Catalyst::Runtime '5.80';
use Catalyst qw(
    ConfigLoader
);

extends 'Catalyst';

our $VERSION = '0.01';

__PACKAGE__->config(
    name => 'SixteenColors::API',
);
__PACKAGE__->setup();

1;

__END__
