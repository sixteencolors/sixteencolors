package SixteenColors::Model::Feeds;

use strict;
use warnings;

use base qw(Catalyst::Model::XML::Feed);

__PACKAGE__->config(
    feeds => [
        {   title => 'news',
            uri =>
                'http://feeds.feedburner.com/SixteenColorsAnsiAndAsciiArchive-News',
        },
        {   title => 'twitter',
            uri   => 'http://twitter.com/statuses/user_timeline/37182331.rss',
        }
    ]
);

sub latest_tweet {
    my $self  = shift;
    my( $entry ) = $self->get( 'twitter' )->entries;

    my $content = $entry->content->body;
    $content =~ s{sixteencolors: }{};
    $content =~ s{(http\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(/\S*)?)}{<a href="$1">$1</a>}g;
    $content =~ s{\@([A-Za-z0-9_]+)}{<a href="http://twitter.com/$1">\@$1</a>}g;
    $content =~ s{#(\w+)}{<a href="search.twitter.com/search?q=%23$1">#$1</a>}g;

    my $date = $entry->issued;
    return {
        link    => $entry->link,
        date    => $date->ymd . ' ' . $date->hms,
        content => $content,
    };
}

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
