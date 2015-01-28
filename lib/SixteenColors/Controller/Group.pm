package SixteenColors::Controller::Group;
use Moose;
use namespace::autoclean;

use JSON ();

BEGIN { extends 'Catalyst::Controller'; }

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched SixteenColors::Controller::Group in Group.');
}

sub autocomplete :Chained('/') :PathPart('group/autocomplete') :Args(0) {
    my ( $self, $c ) = @_;

    my $group_rs = $c->model( 'DB::Group' )->search;
    if( my $query = $c->req->params->{ 'q' } ) {
        $group_rs = $group_rs->search( { name => { like => "${query}%" } } );
    }
    my @groups = map { { name => $_->name, shortname => $_->shortname, id => $_->id } } $group_rs->all;

    $c->response->body( JSON::encode_json( \@groups ) );
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

SixteenColors::Controller::Group - Catalyst Controller

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

