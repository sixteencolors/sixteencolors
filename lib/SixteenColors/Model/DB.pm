package SixteenColors::Model::DB;

use strict;
use warnings;
use parent 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config( schema_class => 'SixteenColors::Schema' );

=head1 NAME

SixteenColors::Model::DB - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
