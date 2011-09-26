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

sub is_development_server {
    my $c = shift;
    return 1 if $c->debug || $c->request->uri->host =~ m{(localhost|beta)};
    return 0;
}

1;

__END__
