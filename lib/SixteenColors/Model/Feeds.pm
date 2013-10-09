package SixteenColors::Model::Feeds;

use Moose;
use namespace::autoclean;

BEGIN {
    extends 'Catalyst::Model::XML::Feed';
}

__PACKAGE__->config(
    feeds => [
        {   title => 'news',
            uri =>
                'http://feeds.feedburner.com/SixteenColorsAnsiAndAsciiArchive-News',
        },
        {   title => 'twitter',
            uri   => 'http://api.twitter.com/1/statuses/user_timeline/sixteencolors.rss',
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
        push @news, {
            content => $content,
            title   => $entry->title,
            link    => $entry->link, 
            date    => $entry->issued->ymd,
        };
    }

    return \@news;
}

1;

__END__

=head1 NAME

SixteenColors::Model::Feeds - Catalyst Model

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 latest_tweets

=head2 latest_news

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
