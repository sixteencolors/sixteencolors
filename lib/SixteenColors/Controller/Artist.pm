package SixteenColors::Controller::Artist;
use Moose;
use namespace::autoclean;

use JSON ();

BEGIN { extends 'Catalyst::Controller'; }

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched SixteenColors::Controller::Artist in Artist.');
}

sub autocomplete :Chained('/') :PathPart('artist/autocomplete') :Args(0) {
    my ( $self, $c ) = @_;

    my $artist_rs = $c->model( 'DB::Artist' )->search;
    if( my $query = $c->req->params->{ 'q' } ) {
        $artist_rs = $artist_rs->search( { name => { like => "${query}%" } } );
    }
    my @artists = map { { name => $_->name, shortname => $_->shortname, id => $_->id } } $artist_rs->all;

    $c->response->body( JSON::encode_json( \@artists ) );
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

SixteenColors::Controller::Artist - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 index

=head2 autocomplete

=encoding utf8

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

