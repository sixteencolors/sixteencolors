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

sub latest_tweets {
    my $self = shift;
    my $number = shift;
    my @tweets;

    my $feed = $self->get( 'twitter' );
    return [] unless $feed;

    my @entries = $feed->entries;
    @entries = @entries[ 0..$number - 1 ] if $number;

    for my $entry ( @entries ) {
        my $content = $entry->content->body;
        $content =~ s{^sixteencolors: }{};
        $content =~ s{(http\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(/\S*)?)}{<a href="$1">$1</a>}g;
        $content =~ s{\@([A-Za-z0-9_/]+)}{<a href="http://twitter.com/$1">\@$1</a>}g;
        $content =~ s{#(\w+)}{<a href="http://search.twitter.com/search?q=%23$1">#$1</a>}g;

        my $date = $entry->issued;
        push @tweets, {
            link    => $entry->link,
            date    => $date->ymd . ' ' . $date->hms,
            content => $content,
        };
    }

    return \@tweets;
}

sub latest_news {
    my $self = shift;
    my $number = shift;
    my @news;

    my $feed = $self->get( 'news' );
    return [] unless $feed;

    my @entries = $feed->entries;
    @entries = @entries[ 0..$number - 1 ] if $number;

    for my $entry ( @entries ) {
        my $content = $entry->summary->body;
        $content =~ s{\[\.\.\.\]}{...};
        push @news, {
            content => $content,
            title   => $entry->title,
            link    => $entry->link, 
            date    => $entry->issued->ymd,
        };
    }

    return \@news;
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
