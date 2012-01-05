package SixteenColors::Controller::Pack;

use Moose;
use namespace::autoclean;
use feature 'switch';
use Data::Dumper;

BEGIN {
    extends 'Catalyst::Controller::HTML::FormFu';
}

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
	my $dir = $c->req->params->{ dir } || 'Asc';
	my $sort = $c->req->params-> { sort } || 'Alpha';

	my $query_sort = '';
	given ($sort) {
		when ("Date Uploaded") { $query_sort = 'ctime ' . $dir . ', canonical_name'}
		when ("Alpha") {$query_sort = 'canonical_name ' . $dir }
		default { $query_sort = 'year ' . $dir .' , month ' . $dir .', canonical_name'}
	}
	
    my $packs
        = $c->model( 'DB::Pack' )
        ->search( {},
        { order_by => $query_sort } );
    my @years
        = grep { defined } $packs->get_column( 'year' )->func( 'DISTINCT' );

# SELECT distinct substr(lower(filename),1,1) as letter, CASE WHEN substr(lower(filename),1,1) > '9' THEN substr(lower(filename),1,1) ELSE '#' END  FROM pack me WHERE ( year = '2003' ) ORDER BY letter

    my $year   = $c->req->params->{ year }   || 'all';
    my $letter = $c->req->params->{ letter } || 'all';
	
	my $year_restrict = $year eq 'all' ? {} : { year => $year};
	
    my $letters = $c->model( 'DB::Pack' )->search(
        $year_restrict ,
        {   select => [
                \'distinct CASE WHEN substr(lower(filename),1,1) > \'9\' THEN substr(lower(filename),1,1) ELSE \'#\' END as letter'
            ],
            as       => [ 'letter' ],
            order_by => 'letter'
        }
    );
    my @letters = $letters->get_column( 'letter' )->all;
    unshift( @letters, 'all' );

    if ( $letter ne '#' ) {
		$year_restrict->{filename} = { like => $letter ne 'all' ? $letter . '%' : '%' };
        $packs = $packs->search(
            $year_restrict
        );
    }
    else {
		my $year_restrict_literal = $year eq 'all' ? '' : 'year = ' . $year . ' and ';
        $packs = $packs->search_literal(
            $year_restrict_literal . 'substr(lower(filename),1,1) in (\'0\',\'1\',\'2\',\'3\',\'4\',\'5\',\'6\',\'7\',\'8\',\'9\')',
            ( $year )
        );
    }

    $packs = $packs->search( {}, { rows => 25, page => $c->req->params->{ page } || 1 } );

    $c->stash(
        packs          => $packs,
        title          => 'Packs',
        years          => \@years,
        current_year   => $year,
        letters        => \@letters,
        current_letter => $letter,
		current_sort   => $sort,
		current_dir    => $dir,
		sort_directions => ['Asc', 'Desc'],
		sort_options 	=> ['Date Released', 'Alpha','Date Uploaded'],
        pager => $packs->pageset,
        serialize_key => 'packs'
    );
}

sub instance : Chained('/') : PathPrefix : CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    my $pack = $c->model( 'DB::Pack' )
        ->find( $id, { key => 'pack_canonical_name' } );

    if ( !$pack ) {
        $c->res->body( '404 Not Found' );
        $c->res->code( '404' );
        $c->detach;
    }

    $c->stash->{ pack } = $pack;

}

sub view : Chained('instance') : PathPart('') : Args(0) : FormConfig {
    my ( $self, $c, $group ) = @_;

    $c->stash( title => $c->stash->{ pack }->canonical_name );

    my $form = $c->stash->{form};


    if ( !$form->submitted ) {
        $form->model->default_values( $c->stash->{ pack } );
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
    my @submitted_groups = split(/,/, $c->req->params->{$key}); # VERY hacky way to get the dynamic autosuggest id
    my @groups = ();

    if (@submitted_groups > 0) {
        foreach(@submitted_groups) {
            $group = $c->model( 'DB::Group' )->find({id => $_});
            if ($group == undef) {
                $group = $c->model( 'DB::Group' )->find({name => $_});
                if ($group == undef && length($_) > 0) { # check one more time to make sure we don't find the group
                    # die Dumper($group);
                    $c->model( 'DB' )->schema->txn_do( sub {
                        $group = $c->model( 'DB::Group' )->create({ name => $_});    
                    });
                    
                }
            }
            if ($group != undef) {
                push(@groups, $group);        
            }
        }    
    } else {
        $group = $c->model( 'DB::Group' )->find({name => $c->req->params->{group}});
        if (!$group && $c->req->params->{group}) {
            $c->model( 'DB' )->schema->txn_do( sub {
                $group = $c->model( 'DB::Group' )->create({ name => $c->req->params->{group}});    
            });
            
        }

        if ($group != undef) {
            push(@groups, $group);        
        }
    }



    $c->model( 'DB' )->schema->txn_do( sub {
        $c->stash->{ pack }->set_groups(@groups);
        $form->model->update( $c->stash->{pack} );       
    });
}

sub preview : Chained('instance') : PathPart('preview') : Args(0) {
    my ( $self, $c ) = @_;

    my $pack = $c->stash->{ pack };
    my $base = '/static/images/p/';
    my $static
        = $base
        . $pack->canonical_name
        . ( exists $c->req->params->{ 's' } ? '-s.png' : '.png' );
    my $path = $c->path_to( "/root${static}" );

    $pack->generate_preview( $c->path_to( "/root${base}" ) ) unless -e $path;
    $c->res->redirect( $c->uri_for( $static ) );
}

sub download : Chained('instance') : PathPart('download') : Args(0) {
    my ( $self, $c ) = @_;

    my $pack = $c->stash->{ pack };
    my $path = $pack->file_path;
    $c->res->header(
        'Content-Disposition' => 'attachment; filename=' . $pack->filename );
    $c->serve_static_file( $path );
}

1;

__END__

=head1 NAME

SixteenColors::Controller::Pack - Catalyst Controller

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

=head2 instance

=head2 view

=head2 preview

=head2 download

=head1 AUTHOR

Sixteen Colors <contact@sixteencolors.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
