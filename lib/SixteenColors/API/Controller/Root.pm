package SixteenColors::API::Controller::Root;

use Moose;
use namespace::autoclean;

use JSON ();

BEGIN {
    extends 'SixteenColors::API::Base::Controller';
}

__PACKAGE__->config(
    namespace => '',
);

sub default : Path {
    my ( $self, $c, @args ) = @_;
    $self->status_bad_request( $c, message => 'Invalid API Request' );
}

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
    my $desc = JSON::decode_json(
        $c->path_to( 'root', 'spore.json' )->slurp
    );
    $desc->{ base_url } = $c->uri_for( '/' )->as_string;
    $self->status_ok( $c, entity => $desc );
}

1;

__END__

=head1 NAME

SixteenColors::API::Controller::Root - Root Controller for SixteenColors

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 default

Attempt to render a view, if needed.

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
