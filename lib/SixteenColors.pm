package SixteenColors;

use strict;
use warnings;

use Catalyst::Runtime 5.80;

use parent qw/Catalyst/;
use Catalyst qw/ConfigLoader
    Authentication
    Cache
    PageCache
    FillInForm
    Session
    Session::Store::FastMmap
    Session::State::Cookie
    Unicode
    Static::Simple/;
our $VERSION = '0.01';

__PACKAGE__->config(
    name                => 'SixteenColors',
    default_view        => 'HTML',
    'Plugin::PageCache' => {
        key_maker => sub {
            my $c = shift;
            return ( $c->stash->{ is_api_call } ? "api/" : "" )
                . $c->req->path
                ; # include "api" in the key if it is an api call so that caching will return the json page rather than html
            }
    },

);

# Start the application
__PACKAGE__->setup();

sub prepare_path {
    my $c = shift;
    $c->next::method( @_ );

    my @path_chunks = split m[/], $c->request->path, -1;

    # Ignore paths that don't are not api calls:
    return unless @path_chunks && $path_chunks[ 0 ] eq "api";

    # Create modified request path from any remaining path chunks:
    my $path = join( '/', @path_chunks ) || '/';

    # Stuff modified request path back into request:
    $c->request->path( $path );

    # Modify the path part of the request base
    # to include the path prefix:
    my $base = $c->request->base;
    $base->path( $base->path . "api/" );

    $c->stash(
        is_api_call           => 1,
        current_view_instance => $c->view( 'JSON' )
    );    # remember whether this is an api call
    return;
}

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
