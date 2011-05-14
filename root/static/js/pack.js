var items = new Array();
var selector = "#pack li:not(.noscroll),#prev:not(.noscroll),#next:not(.noscroll),#results li:not(.noscroll),#randomworks li:not(.noscroll)";
$( document ).ready( function() {
	$('#years').selectmenu({style: 'popup',
		change: function(e, object){
				$('#letters').selectmenu("index", 0);
				$('#Filter').submit();
		    }	
	});
	$('#letters').selectmenu({style: 'popup',
		change: function(e, object) {
			$('#Filter').submit();
		}
	});
    $('#pack').masonry( { columnWidth: 8, itemSelector: 'h2,li,div' } );
    $('#results').masonry( { columnWidth: 8, itemSelector: 'h2,li,div' } );

    var packitems = $('#pack li,#prev,#next,#results li,#randomworks li').not('.noscroll');

    packitems.each(function() {
        items.push(new PackItem(items.length));
        items[items.length-1].getHeightFromElement(this);
    });

    packitems.mouseover(function(){
        if( !items[$(this).index(selector)].running ) {
            items[$(this).index(selector)].direction = items[$(this).index(selector)].direction * -1;
        }
        animate(this);
    })
    .click(function() {
        items[$(this).index(selector)].direction = items[$(this).index(selector)].direction * -1;
        animate(this);
    })
    .mouseout(function(){
        $(this).stop(true);
    });

    // text-overflow
    $('#newpacks li a,#packs li a,#pack li a,#prev a,#next a,#results li a,#randomworks li a').not('.noscroll').textOverflow();
} );

function animate(ele) {
    var item   = items[ $(ele).index(selector) ];
    var height = item.height;
    var dir    = item.direction;
    var pos    = parseInt( $(ele).css( 'background-position' ).match( /([\d\.]+)(?:px|%)$/ ) );
    item.running = 1;
    $(ele).stop();
    $(ele).animate(
        {backgroundPosition:"0 -" + ( dir < 0 ? height - $(ele).height() : 0 ) + "px"}, 
        {
            easing: 'linear',
            duration: ( dir < 0 ? height - $(ele).height() - pos : pos ) * 10,
            complete: function() {
                item.running = 0;
            }
        }
    );     
}

function PackItem(index, args) {
    this.index = index;
    this.running = 0;
    this.direction = 1;
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
    });
    $("body").append(img);

    this.src = url;
}

