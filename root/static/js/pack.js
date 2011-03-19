var scroll_e;
var scroll_t;
var scroll_d;
var scroll_h;
var scroll_i;
var items = new Array();

$( document ).ready( function() {
    $('#pack').masonry( { columnWidth: 8, itemSelector: 'h2,li,div' } );

	$('#pack li').each(function() {
		items.push(new PackItem(items.length));
		items[items.length-1].getHeightFromElement(this);
	});
    $('#pack li,#prev,#next').filter('[class!=noscroll]').mouseenter(
        function() {
            scroll_e = this;
            scroll_d = -1;
			scroll_i = $(this).index();
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

function PackItem(index, args) {
	this.index = index;
	if (args !== undefined) {
		this.height = "height" in args ? args["height"] : 0;
		this.top = "top" in args ? args["top"] : 0;
		this.src = "path" in args ? args["path"] : "";
	} else {
		this.height = this.top = 0;
		this.src = "";
	}
}

PackItem.prototype.getHeightFromElement = function(ele) {
	var pattern=/\"|\'|\)|\(|url/g;
	var url = $(ele).css('background-image').replace(pattern,'');
	var img = $('<img />');
	img.attr("src", url);
	img.hide();
	this.height = 0;
	
	img.load({index:this.index, boxHeight:$(ele).height()},function(event) {
		items[event.data.index].height = $(this).height() - event.data.boxHeight;
	});
	$("#pack").append(img);
	
	// this.height = height;
	this.src = url;
}

function getImageHeight() {
	var pattern=/\"|\'|\)|\(|url/g;
	var url = $(scroll_e).css('background-image').replace(pattern,'');
	var img = $('<img />');
	img.attr("src", url);
	img.hide();
	img.load(function() {
		scroll_h = $(this).height() - $(scroll_e).height();
	});
	$("#pack").append(img);
}


function scrollBg() {
	var match = /(-?\d+)px$/;
    var val = $(scroll_e).css( "background-position" );
    if( /%/.test( val ) ) {
        val = '0 0px';
    } 
	var max = 4;
	var item = items[scroll_i];
	if (match.exec(val))
		item["top"] = match.exec(val)[1];

	var start = item["top"] * -1;
	var stop = scroll_d < 0 ? item["height"] : 0;
	distance = stop > start ? stop - start : start - stop;
	var step = Math.round((distance < item["height"] ? distance : item["height"] - distance + 20) / 20);
	if (step >= max) step = max;
	val = val.replace( match, function( str, p1, offet, s ){ return ( parseInt( p1 ) + scroll_d * step ) + "px"; } );
	if (match.exec(val))
		items[scroll_i]["top"] = match.exec(val)[1];
    $(scroll_e).css( "background-position", val ); 
    scroll_t = setTimeout( 'scrollBg()', 10 );
}

