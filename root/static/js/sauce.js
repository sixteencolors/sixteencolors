$( document ).ready( function() {
    $('#sauce h3').click( function() {
        $( '#sauce dl' ).slideToggle( 'slow', function() {
            if ( $( '#sauce dl' ).is( ':visible' ) ) {
                $('#sauce h3').html( 'Hide SAUCE Record <span>&uarr;</span>' );
            }
            else {
                $('#sauce h3').html( 'View SAUCE Record <span>&darr;</span>' );
            }
        } );
    } );
} );

