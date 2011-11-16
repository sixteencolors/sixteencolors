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
        my %opts = (
            page => $c->req->params->{ page } || 1,
            rows => $c->req->params->{ rows }
        );

        if( !defined $opts{ rows } ) {
            $opts{ rows } = 30;
        }

        if( $opts{ rows } != 0 ) {
            $entity = $entity->search( {}, \%opts );
            my $pager = $entity->pager;
            $c->stash->{ $self->{'stash_key'} } = $entity;

            my %paging = ( first => 'first', last => 'last', next => 'next', previous => 'prev' );
            my @links;
            for ( keys %paging ) {
                my $m = "${_}_page";
                next unless defined $pager->$m;
                $opts{ page } = $pager->$m;
                push @links, sprintf( qq(<%s>; rel="$paging{$_}"), $c->req->uri_with( \%opts ) );
            }

            $c->res->header( 'Link' => join( ',', @links ) );
        }
    }

    $self->config->{ json_options }->{ pretty } = $c->is_development_server;
    $c->forward( 'serialize' );
    $c->res->content_type( $c->res->content_type . '; charset=utf-8' );
}

sub serialize : ActionClass('Serialize') {}

1;
