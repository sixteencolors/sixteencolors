$( document ).ready( function() {
    $('#sauce h3').click( function() {
        $( '#sauce>div' ).slideToggle( 'slow', function() {
            if ( $( '#sauce>div' ).is( ':visible' ) ) {
                $('#sauce h3').html( 'Hide SAUCE Record <span>&uarr;</span>' );
            }
            else {
                $('#sauce h3').html( 'View SAUCE Record <span>&darr;</span>' );
            }
        } );
    } );
    $('#disqus_container>h3').click( function() {
        $( '#disqus_container>div' ).slideToggle( 'slow', function() {
            if ( $( '#disqus_container>div' ).is( ':visible' ) ) {
                $('#disqus_container>h3').html( 'Hide discussion <span>&uarr;</span>' );
            }
            else {
                $('#disqus_container>h3').html( 'View discussion<span>&darr;</span>' );
            }
        } );
    } );
} );

