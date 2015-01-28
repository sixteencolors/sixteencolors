package SixteenColors::Controller::Tag;
use Moose;
use namespace::autoclean;

use JSON ();

BEGIN { extends 'Catalyst::Controller'; }

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched SixteenColors::Controller::Tag in Tag.');
}

sub autocomplete :Chained('/') :PathPart('tag/autocomplete') :Args(0) {
    my ( $self, $c ) = @_;

    my $tag_rs = $c->model( 'DB::Tag' )->search;
    if( my $query = $c->req->params->{ 'q' } ) {
        $tag_rs = $tag_rs->search( tag => { like => "${query}%" } );
    }
    my @tags = map { { name => $_->tag } } $tag_rs->all;

    $c->response->body( JSON::encode_json( \@tags ) );
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

SixteenColors::Controller::Tag - Catalyst Controller

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

