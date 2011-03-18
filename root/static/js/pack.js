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
	if (match.exec(val))
		top = match.exec(val)[1];
	
	getImageHeight();
	console.log(scroll_h + ": " + top);
    if( /%/.test( val ) ) {
        val = '0 0px';
    } 
	if ((top * -1 >= scroll_h && scroll_d == -1) || top == 0 && scroll_d == 1) {
		val = val;
	} else {
    	val = val.replace( match, function( str, p1, offet, s ){ return ( parseInt( p1 ) + scroll_d ) + "px"; } );
	}
    $(scroll_e).css( "background-position", val ); 
    scroll_t = setTimeout( 'scrollBg()', 10 );
	
//	console.log(match.exec(val)[1]);
	
	/*
	console.log("Background Image:" + $("<img src=\"images/menu-"+name+"-h.png\" />").attr('src',function(){
	    return $(scroll_e).css('background-image').replace(pattern,'');}).attr("src"));
	

	$("<img src=\"images/menu-"+name+"-h.png\" />").attr('src',function(){
	    return $(scroll_e).css('background-image').replace(pattern,'');
	}).load(function(){
	    w = $(this).width();
	    h = $(this).height();
		console.log($(this).attr("src") + ": " + h + "/" + w);
	});
	*/
}
