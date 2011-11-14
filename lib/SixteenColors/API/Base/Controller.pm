package SixteenColors::API::Base::Controller;

use Moose;
use namespace::autoclean;

BEGIN {
    extends 'Catalyst::Controller::REST';
}

__PACKAGE__->config(
    content_type_stash_key => 'content_type',
    map => {
        'application/json' => 'SixteenColors::API::JSON'
    },
);

sub begin : Private {
    my ( $self, $c ) = @_;
    $c->stash->{ content_type } = 'application/json';
    $c->forward( 'deserialize' );
}

sub deserialize : ActionClass('Deserialize') {}

sub end : Private {
    my( $self, $c ) = @_;
    my $entity = $c->stash->{ $self->{'stash_key'} };

    if( blessed $entity && $entity->isa( 'DBIx::Class::ResultSet' ) ) {
        my $page = $c->req->params->{ page } || 1;
        my $rows = $c->req->params->{ rows } || 30;
        $rows = 100 if $rows > 100;

        $entity = $entity->search( {}, { rows => $rows, page => $page } );
        my $pager = $entity->pager;
        $c->stash->{ $self->{'stash_key'} } = $entity;

        my %paging = ( first => 'first', last => 'last', next => 'next', previous => 'prev' );
        my @links;
        for ( keys %paging ) {
            my $m = "${_}_page";
            next unless defined $pager->$m;
            push @links, sprintf( qq(<%s>; rel="$paging{$_}"), $c->req->uri_with( { page => $pager->$m, rows => $rows } ) );
        }

        $c->res->header( 'Link' => join( ',', @links ) );
    }

    $self->config->{ json_options }->{ pretty } = $c->is_development_server;
    $c->forward( 'serialize' );
    $c->res->content_type( $c->res->content_type . '; charset=utf-8' );
}

sub serialize : ActionClass('Serialize') {}

1;
