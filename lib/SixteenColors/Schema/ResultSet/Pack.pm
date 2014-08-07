package SixteenColors::Schema::ResultSet::Pack;

use strict;
use warnings;

use parent 'DBIx::Class::ResultSet';

use Try::Tiny;
use Directory::Scratch;
use File::Basename ();

sub new_from_file {
    # TODO get $c, so we have an app context
    my ( $self, $file, $year ) = @_;

    if( -d $file ) {
        die 'Target to be indexed must be a regular file';
    }

    if( $file !~ m{\.zip$}i ) {
        die "${file} is not a zip file";
    }

    my $basename = File::Basename::basename( $file );
    if ( $self->search( { filename => $basename } )->count ) {
        die "A file of the same name (${basename}) has already been indexed";
    }

    my $schema = $self->result_source->schema;
    my $pack;

    try {
        $schema->txn_do( sub {
            $pack
                = $self->create( { file_path => "${file}", year => $year } );
            $pack->index;

        } );
    }
    catch {
        die $_;
    };

    return $pack;
}

1;

