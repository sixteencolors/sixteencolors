package SixteenColors;

use strict;
use warnings;

use Catalyst::Runtime 5.80;

use parent qw/Catalyst/;
use Catalyst qw/ConfigLoader
    Authentication
    Session
    Session::Store::FastMmap
    Session::State::Cookie
    Unicode
    Static::Simple/;
our $VERSION = '0.01';

__PACKAGE__->config( name => 'SixteenColors' );

# Start the application
__PACKAGE__->setup();

=head1 NAME

SixteenColors - Catalyst based application

=head1 SYNOPSIS

    script/sixteencolors_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<SixteenColors::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Brian Cassidy,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
