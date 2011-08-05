$( document ).ready( function() {
    // Login drop-down
    var loginlink = $( '#auth h2 a.login' );
    loginlink.append( ' &darr;' );

    loginlink.click( function() {
        $( '#auth form' ).slideToggle( 'slow', function() {
            loginlink.html( $( this ).is( ':visible' ) ? 'Login &uarr;' : 'Login &darr;' );
        } );
        return false;
    } );

    // Parallax scrolling header
    for ( var i = 3; i >= 1; i-- ) {
        var p = $( '<div class=parallax id=parallax' + i + '></div>' );
        p.data( 'scrollPosition', 0 );
        p.data( 'scrollSpeed', 30 * i );
        $( 'body' ).prepend( p );
    }

    var parallax = $( '.parallax' );

    $( 'h1' ).mouseover( function() {
        parallax.each( function() {
            var p = $(this);
            p.data( 'scrollID', setInterval( function() {
                var pos = p.data( 'scrollPosition' ) - 1;
                p.css( 'backgroundPosition', pos + 'px 0' );
                p.data( 'scrollPosition', pos );
            }, p.data( 'scrollSpeed' ) ) );
        } );
    } )
    .mouseout( function() {
        parallax.each( function() {
            clearInterval( $( this ).data( 'scrollID') );
        } );
    } );

    // Random files
    $( '#random .morelinks a' ).click( function() {
        var random = $( '#random ul.gallery' );
        random.slideUp( 'slow', function() {
            random.children().remove();
        } );

        $.getJSON( '/api/file/random?callback=?', function( files ) {
            $.each( files, function() {
                var file = $( '<li></li>' );
                file.attr( 'class', 'grid_3' );
                file.css( 'background-image', 'url(' + this.thumbnail + '?s=1)' );

                file.html( '<a href="' + this.uri + '"><span>' + this.filename + '<br />' + this.pack.name + '</span></a>'
                    + '<dl class=toolbar></dl>' );

                random.append( file );
            } );
            random.slideDown();
            make_scrollable( random.children() );
        } );

        return false;
    } );

    // Disqus dropdown
    $( '.morelinks a.disqus' ).click( function() {
        $( '#disqus_container' ).slideToggle();
    } );
    

    // Scroll background images
    make_scrollable( $( '.gallery li' ) );

} );

function make_scrollable ( gallery ) {
    // calculate image height, set default values
    gallery.each( function() {
        var item    = $(this);
        var pattern = /\"|\'|\)|\(|url/g;
        var url     = item.css( 'background-image' ).replace( pattern, '' );

        if( url == 'none' ) {
            return;
        }

        var img = $( '<img />' )
            .attr( 'src', url )
            .hide()
            .load( function() {
                item.data( 'scrollHeight', $(this).height() );
            } );

        $( 'body' ).append( img );
    } );

    gallery.mousemove( function( e ) {
        var item   = $(this);
        var height = item.data( 'scrollHeight' );

        if( height == null ) {
            return;
        }

        var pos    = parseInt( item.css( 'background-position' ).match( /([\d\.]+)(?:px|%)$/ ) );
        var offset = item.height() / 2 - ( e.pageY - $(this).offset().top );

        item.stop( true );
        item.animate(
            { backgroundPosition: '0 -' + ( offset < 0 ? height - item.height() : 0 ) + 'px' }, 
            {
                easing: 'linear',
                duration: ( offset < 0 ? height - item.height() - pos : pos ) * 450 / Math.abs( offset ),
            }
        );     
    } )
    .mouseout( function() {
        $( this ).stop( true );
    } );
}

