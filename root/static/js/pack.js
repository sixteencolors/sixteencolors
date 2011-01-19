var scroll_e;
var scroll_t;
var scroll_d;

$( document ).ready( function() {
    $('#pack').masonry( { columnWidth: 8, itemSelector: 'h2,li,div' } );

    $('#pack li,#prev,#next').filter('[class!=noscroll]').mouseenter(
        function() {
            scroll_e = this;
            scroll_d = -1;
            scroll_t = setTimeout( 'scrollBg()', 10 );
        }    
    )
    .mouseleave(
        function() { clearTimeout( scroll_t ); }
    )
    .click(
        function() { scroll_d *= -1; }
    );
} );

function scrollBg() {
    var val = $(scroll_e).css( "background-position" );

    if( /%/.test( val ) ) {
        val = '0 0px';
    }

    val = val.replace( /(-?\d+)px$/, function( str, p1, offet, s ){ return ( parseInt( p1 ) + scroll_d ) + "px"; } );
    $(scroll_e).css( "background-position", val ); 
    scroll_t = setTimeout( 'scrollBg()', 10 );
}
