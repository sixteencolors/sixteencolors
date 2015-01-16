package SixteenColors::Schema::ResultSet::Pack;

use strict;
use warnings;

use parent 'DBIx::Class::ResultSet';

use Try::Tiny;
use Directory::Scratch;
use File::Basename ();
use File::Copy ();
use File::Path ();

sub new_from_file {
    my ( $self, $c, $opts ) = @_;
    my $file = $opts->{ file };

    if( -d $file ) {
        die 'Target to be indexed must be a regular file';
    }

    if( $file !~ m{\.zip$}i ) {
        die "${file} is not a zip file";
    }

    my $basename = File::Basename::basename( $file );
    if ( $self->search( { filename => $basename } )->count ) {
        die "A file of the same name (${basename}) has already been indexed" unless $opts->{ reindex };
        $self->single( { filename => $basename } )->files->delete;
    }

    my $schema = $self->result_source->schema;
    my $pack;

    try {
        $schema->txn_do( sub {
            $pack
                = $self->update_or_create( { file_path => "${file}", year => $opts->{ year } } );
            $pack->index( $c );
            my $destfile = $c->path_to( 'root', 'static', 'packs', $opts->{ year }, $basename );
            my $destdir  = $destfile->dir;
            if( !-e "${destfile}" ) {
                File::Path::mkpath( "${destdir}" );
                File::Copy::copy( "${file}", "${destfile}" );
            }
        } );
    }
    catch {
        die $_;
    };

    return $pack;
}

sub recent {
    my ( $self ) = @_;
    return $self->search( {}, { order_by => 'ctime DESC' } );
}

1;

