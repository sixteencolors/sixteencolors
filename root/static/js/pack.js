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
//		$(this).css("height", items[items.length-1].height + "px");
	});
	
    $('#pack li,#prev,#next').filter('[class!=noscroll]').mouseover(function(){
				animate(this);
			})
			.click(function() {
				items[$(this).index()].direction = items[$(this).index()].direction * -1;
				animate(this);
			})
			.mouseout(function(){
				$(this).stop(true);
			});
} );

function animate(ele) {
	$(this).stop();
	$(ele).animate(
		{backgroundPosition:"0 -" + (items[$(ele).index()].direction < 0 ? (items[$(ele).index()].height - $(ele).height()) : 0) + "px"}, 
		{duration: 5000});
	
}

function PackItem(index, args) {
	this.index = index;
	this.direction = -1;
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
		items[event.data.index].height = $(this).height();
		// $(ele).children("a").css("height", $(this).height() + "px");
	});
	$("#pack").append(img);
	
	//this.height = height;
	this.src = url;
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

