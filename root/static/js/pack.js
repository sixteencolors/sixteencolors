var scroll_c = 0;
var scroll_e;
var scroll_t;

$( document ).ready( function() {
    $('#pack').masonry( { columnWidth: 8, itemSelector: 'h2,li,div' } );

    $('#pack li,#prev,#next').filter('[class!=noscroll]').mouseenter(
        function() {
            scroll_e = this;
            scroll_t = setTimeout( 'scrollBg()', 10 );
        }    
    ).mouseleave(
        function() {
            scroll_c = 0;
            clearTimeout( scroll_t );
            $(this).css( "background-position", "0 0" );
        }
    );

} );

function scrollBg() {
    scroll_c -= 1;
    $(scroll_e).css( "background-position", "0 " + scroll_c + "px" );
    scroll_t = setTimeout( 'scrollBg()', 10 );
}
