package SixteenColors::Controller::File;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }


sub view : Chained('/pack/instance') : PathPart('') : Args() {
    my ( $self, $c, @parts ) = @_;
    my $id = join( '/', @parts );

    my $file = $c->stash->{ pack }->files( { file_path => $id } )->first;

    if ( !$file ) {
        $c->res->body( '404 Not Found' );
        $c->res->code( '404' );
        $c->detach;
    }

    $c->stash->{ file } = $file;

}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

SixteenColors::Controller::File - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 view

=encoding utf8

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
