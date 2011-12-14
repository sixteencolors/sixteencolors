package SixteenColors::API::View::HTML;

use strict;
use warnings;
use base 'Catalyst::View::TT';

__PACKAGE__->config( TEMPLATE_EXTENSION => '.tt', WRAPPER => 'wrapper.tt' );

=head1 NAME

SixteenColors::API::View::HTML - TT View for SixteenColors::API

=head1 DESCRIPTION

TT View for SixteenColors::API.

=head1 SEE ALSO

L<SixteenColors>

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
