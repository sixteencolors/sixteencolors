package SixteenColors::View::HTML;

use strict;
use warnings;
use base 'Catalyst::View::TT::Alloy';

__PACKAGE__->config(
    AUTO_FILTER        => 'html',
    ENCODING           => 'utf8',
    RECURSION          => 1,
    TEMPLATE_EXTENSION => '.tt',
    WRAPPER            => 'wrapper.tt'
);

=head1 NAME

SixteenColors::View::HTML - Template::Alloy::TT View for SixteenColors

=head1 DESCRIPTION

Template::Alloy::TT View for SixteenColors. 

=head1 SEE ALSO

L<SixteenColors>

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
