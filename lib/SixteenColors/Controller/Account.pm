package SixteenColors::Controller::Account;

use Moose;
use namespace::autoclean;

BEGIN {
    extends 'Catalyst::Controller::HTML::FormFu';
}

sub account : Path('/account') Args(0) FormConfig {
    my ( $self, $c ) = @_;

    $c->stash( title => 'My Account' );

    $c->res->redirect( $c->uri_for( '/' ) )
        unless $c->user_exists;

    my $form = $c->stash->{form};

    if ( !$form->submitted ) {
        $form->model->default_values( $c->user );
        return;
    }

    $form->model->update( $c->user );
}

1;

__END__

=head1 NAME

SixteenColors::Controller::Account - Catalyst Controller

=head1 DESCRIPTION

This is the controller class for user configurable account settings.

=head1 METHODS

=head2 account

=head2 ...

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
