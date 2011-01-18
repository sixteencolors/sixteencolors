var scroll_e;
var scroll_t;

$( document ).ready( function() {
    $('#pack').masonry( { columnWidth: 8, itemSelector: 'h2,li,div' } );

    $('#pack li,#prev,#next').filter('[class!=noscroll]').mouseenter(
        function() {
            scroll_e = this;
            scroll_t = setTimeout( 'scrollBg()', 10 );
        }    
    )
    .mouseleave(
        function() { clearTimeout( scroll_t ); }
    );
} );

function scrollBg() {
    var val = $(scroll_e).css( "background-position" );

    if( /%/.test( val ) ) {
        val = '0 0px';
    }

    val = val.replace( /(-?\d+)px$/, function( str, p1, offet, s ){ return ( parseInt( p1 ) - 1 ) + "px"; } );
    $(scroll_e).css( "background-position", val ); 
    scroll_t = setTimeout( 'scrollBg()', 10 );
}
