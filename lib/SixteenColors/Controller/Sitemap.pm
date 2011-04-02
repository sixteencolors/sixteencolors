package SixteenColors::Controller::Sitemap;
use Moose;
use namespace::autoclean;

use POSIX ();

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

SixteenColors::Controller::Sitemap - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    my $pages = POSIX::ceil( $c->model( 'DB::File' )->count / 50000 );
    $c->cache_page();

    $c->stash( no_wrapper => 1, pages => $pages );
}

sub pack : Path('pack') {
    my ( $self, $c ) = @_;
    $c->cache_page();
    my $packs
        = $c->model( 'DB::Pack' )
        ->search( {},
        { order_by => 'year DESC, month DESC, canonical_name' } );
    $c->stash( no_wrapper => 1, packs => $packs );
}

sub file : Path('file') : Args(0) {
    my ( $self, $c ) = @_;
    $c->cache_page();
    my $files
        = $c->model( 'DB::File' )
        ->search( {},
        { page => $c->req->params->{ page } || 1, rows => 50000 } );

    $c->stash( no_wrapper => 1, files => $files );

}

=head1 AUTHOR

Doug Moore,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
