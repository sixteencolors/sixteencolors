package SixteenColors;

use Moose;
use namespace::autoclean;

use 5.10.0;
use Catalyst::Runtime '5.80';
use Catalyst qw(
    ConfigLoader
    Authentication
    Cache
    FillInForm
    Session
    Session::Store::FastMmap
    Session::State::Cookie
    Unicode
    PageCache
    Static::Simple
);
use CatalystX::RoleApplicator;

extends 'Catalyst';

our $VERSION = '0.01';

__PACKAGE__->apply_request_class_roles( 'SixteenColors::Role::Request' );
__PACKAGE__->config(
    name                => 'SixteenColors',
    default_view        => 'HTML',
    'Plugin::PageCache' => {
        disable_index   => 1,
        auto_check_user => 1,
        cache_hook      => 'pagecache_hook',
        key_maker       => sub {
            my $c = shift;
            my $view = lc ref $c->view;
            $view =~ s{^.+view\::}{};

            # Returns the original uri plus the view type in case we allow
            # the same uri to be view-dependant
            my $key = sprintf( "[%s] %s", $view, $c->request->original_uri );
            return $key;
        }
    },
    'Plugin::Authentication' => {
        default_realm => 'openid',
        realms        => {
            openid => {
                class      => '+SixteenColors::Authentication::Realm::OpenID',
                credential => { class => 'OpenID', },
                store      => {
                    class         => 'DBIx::Class',
                    user_model    => 'DB::Account',
                    id_field      => 'id',
                    role_relation => 'roles',
                    role_field    => 'name',
                },
            },
        }
    },
);

# Start the application
__PACKAGE__->setup();

sub is_development_server {
    my $c = shift;
    return 1 if $c->debug || $c->request->uri->host =~ m{(localhost|beta)};
    return 0;
}

sub pagecache_hook {
    my $c = shift;
    return !$c->is_development_server;
}

sub prepare_path {
    my $c = shift;
    $c->next::method( @_ );
    $c->request->original_uri( $c->request->uri );

    my @path_chunks = split m[/], $c->request->path, -1;

    # Ignore paths that don't are not api calls:
    return unless @path_chunks > 1 && $path_chunks[ 0 ] eq "api";

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
