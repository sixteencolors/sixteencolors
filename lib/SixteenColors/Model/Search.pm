package SixteenColors::Model::Search;

use Moose;
use namespace::autoclean;
use LWP::UserAgent;
use XML::Simple;
use Data::Pageset;

BEGIN {
    extends 'Catalyst::Model';
}

with 'Catalyst::Component::InstancePerContext';

has 'api_key' => ( isa => 'Str', is => 'ro' );

has 'agent' => ( isa => 'LWP::UserAgent', is => 'ro', default => sub { LWP::UserAgent->new } );

has 'xml_parser' => ( isa => 'XML::Simple', is => 'ro', default => sub { XML::Simple->new( ForceArray => [ 'R' ] ) } );

has 'ctx' => ( is => 'ro', isa => 'Object', weak_ref => 1 );

sub build_per_context_instance {
    my ( $self, $c, @args ) = @_;
    return $self unless( ref $c );

    my $class = ref( $self ) || $self;
    return $class->new( { %{ $self || {} }, ctx => $c, @args } );
}

sub search {
    my( $self, $q, $opts ) = @_;
    my $c = $self->ctx;

    my $page = delete $opts->{ page } || $c->req->params->{ page } || 1;
    $opts->{ num }   ||= 20; # Google will not return more than 20 per page
    $opts->{ start }   = ( $page - 1 ) * $opts->{ num };

    my $uri = URI->new( 'http://www.google.com/search' );
    $uri->query_form ( {
        q      => $q,
        hl     => 'en',
        output => 'xml',
        client => 'google-csbe',
        cx     => $self->api_key,
        %$opts
    } );

    my $res = {};
    $res->{ http } = $self->agent->get( $uri );

    return unless $res->{ http }->is_success;

    $res->{ data } = $self->xml_parser->XMLin( $res->{ http }->content );

    if( exists $res->{ data }->{ RES } ) {
        $res->{ pager } = Data::Pageset->new( {
            total_entries    => $res->{ data }->{ RES }->{ M },
            entries_per_page => $res->{ data }->{ PARAM }->{ num }->{ value },
            current_page     => $opts->{ page }
        } );
    }

    return $res;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

SixteenColors::Model::Search - Catalyst Model

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
