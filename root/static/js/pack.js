var scroll_e;
var scroll_t;
var scroll_d;
var scroll_h;

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

function getImageHeight() {
	var pattern=/\"|\'|\)|\(|url/g;
	var url = $(scroll_e).css('background-image').replace(pattern,'');
	var img = $('<img />');
	img.attr("src", url);
	img.hide();
	img.load(function() {
		scroll_h = $(this).height() - $(scroll_e).height();
		//console.log(height);
	});
	$("#pack").append(img);
}



function scrollBg() {
	var match = /(-?\d+)px$/;
    var val = $(scroll_e).css( "background-position" );
	var top = 0;
	var max = 6;
	if (match.exec(val))
		top = match.exec(val)[1];
	
	getImageHeight();
	
	
	var startY = top * -1;
	var stopY = scroll_h;
	if (scroll_d > 0) {
		stopY = 0;
	}
    var distance = stopY > startY ? stopY - startY : startY - stopY;
    var step = Math.round((distance < scroll_h/2  ? distance:  scroll_h - distance + 20) / 20);
	if (step >= max) step = max;
    var leapY = stopY > startY ? startY + step : startY - step;
	if (startY == leapY) scroll_d = scroll_d * -1;

	console.log("starty: " + startY + " stopy: " + stopY + " distance: " + distance + " step: " + step + " leap: " + leapY);
	
    if( /%/.test( val ) ) {
        val = '0 0px';
    } 

	val = val.replace( match, function( str, p1, offet, s ){ return ( parseInt( p1 ) + scroll_d * step ) + "px"; } );
    $(scroll_e).css( "background-position", val ); 
    scroll_t = setTimeout( 'scrollBg()', 10 );
	
}
