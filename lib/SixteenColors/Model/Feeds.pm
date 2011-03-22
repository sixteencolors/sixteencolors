package SixteenColors::Model::Feeds;

use strict;
use warnings;

use base qw(Catalyst::Model::XML::Feed);

__PACKAGE__->config(
    feeds => [ 
        {
            title => 'news',
            uri   => 'http://feeds.feedburner.com/SixteenColorsAnsiAndAsciiArchive-News',
        }
    ]
);

=head1 NAME

SixteenColors::Model::Feeds - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.

=head1 AUTHOR

Doug Moore,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.


=cut
1;
