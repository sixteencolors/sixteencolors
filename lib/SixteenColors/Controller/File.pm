package SixteenColors::Controller::File;

use Moose;
use namespace::autoclean;
use Data::Dumper;

BEGIN {
    extends 'Catalyst::Controller::HTML::FormFu';
}

use File::Basename ();

=head1 NAME

SixteenColors::Controller::File - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

sub instance : Chained('/pack/instance') : PathPart('') : CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    my $file = $c->stash->{ pack }->files( { filename => $id } )->first;

    if ( !$file ) {
        $c->res->body( '404 Not Found' );
        $c->res->code( '404' );
        $c->detach;
    }

    $c->stash->{ file } = $file;

}

sub view : Chained('instance') : PathPart('') : Args(0) : FormConfig {
    my ( $self, $c, $artist ) = @_;
    $c->stash( title => $c->stash->{ file }->filename );

    #$c->model( 'DB' )->schema->bootstrap_journal(); # Needed to setup journaling schema

    my $form = $c->stash->{form};
    # die Dumper($c->stash->{file}->artists);


    if ( !$form->submitted ) {
        $form->model->default_values( $c->stash->{ file } );
        return;
    }

    my @keys = keys %{$c->req->params};
    my $key;
    foreach(@keys) {
        if ($_ =~ m/as_value/) {
            $key = $_;
        }
    }

    $c->model( 'DB' )->schema->changeset_user($c->user->id);
    my @submitted_artists = split(/,/, $c->req->params->{$key}); # VERY hacky way to get the dynamic autosuggest id
    # die Dumper(@submitted_artists);
    my @artists = ();

    foreach(@submitted_artists) {
        $artist = $c->model( 'DB::Artist' )->find({id => $_});
        if ($artist == undef) {
            $artist = $c->model( 'DB::Artist' )->find({name => $_});
            if ($artist == undef && length($_) > 0) { # check one more time to make sure we don't find the artist
                $c->model( 'DB' )->schema->txn_do( sub {
                    $artist = $c->model( 'DB::Artist' )->create({ name => $_});    
                });
                
            }
        }
        # die Dumper($_);
        if ($artist != undef) {
            push(@artists, $artist);        
        }
        # die Dumper($artist);
    }    

    # die Dumper(@artists);


    $c->model( 'DB' )->schema->txn_do( sub {
        $c->stash->{ file }->set_artists(@artists);
        $form->model->update( $c->stash->{file} );       
    });
    
}

sub preview : Chained('instance') : PathPart('preview') : Args(0) {
    my ( $self, $c ) = @_;

    my $file = $c->stash->{ file };
    my $pack = $c->stash->{ pack };

    if ( !$file->is_artwork ) {
        my $type = $file->is_audio ? 'audio' : 'binary';
        $c->res->redirect(
            $c->uri_for( "/static/images/${type}-preview.png" ) );
        return;
    }

    # user-options
    my $params = $c->req->params;
    my %options = map { $_ => $params->{ $_ } }
        grep { defined $params->{ $_ } && length $params->{ $_ } }
        keys %$params;

    if ( $c->user_exists && keys %options ) {
        my $tmp = $file->generate_thumbnail( undef, \%options );
        $c->serve_static_file( $tmp );
        return;
    }

    my $fn   = $file->filename . '.png';
    my $url  = join( '/', '/static/images/t', $pack->canonical_name );
    my $path = $c->path_to( "/root${url}/$fn" );
    $file->generate_thumbnail( $path ) unless -e $path;
    $c->res->redirect( $c->uri_for( $url, $fn ) );
}

sub fullscale : Chained('instance') : PathPart('fullscale') : Args(0) {
    my ( $self, $c ) = @_;

    my $file = $c->stash->{ file };
    my $pack = $c->stash->{ pack };

    if ( !$file->is_artwork ) {
        my $type = $file->is_audio ? 'audio' : 'binary';
        $c->res->redirect(
            $c->uri_for( "/static/images/${type}-preview.png" ) );
        return;
    }

    # user-options
    my $params = $c->req->params;
    my %options = map { $_ => $params->{ $_ } }
        grep { defined $params->{ $_ } && length $params->{ $_ } }
        keys %$params;

    if ( $c->user_exists && keys %options ) {
        my $tmp = $file->generate_fullscale( undef, \%options );
        $c->serve_static_file( $tmp );
        return;
    }

    my $fn = $file->filename . ( $file->is_bitmap ? '' : '.png' );
    my $url = join( '/', '/static/images/f', $pack->canonical_name );
    my $path = $c->path_to( "/root${url}/$fn" );
    $file->generate_fullscale( $path ) unless -e $path;
    $c->res->redirect( $c->uri_for( $url, $fn ) );
}

sub download : Chained('instance') : PathPart('download') : Args(0) {
    my ( $self, $c ) = @_;
    my $file = $c->stash->{ file };
    my $pack = $c->stash->{ pack };

    $c->res->header( 'Content-Disposition' => 'attachment; filename='
            . File::Basename::basename( $file->file_path ) );
    $c->res->body( $file->slurp );
}

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
