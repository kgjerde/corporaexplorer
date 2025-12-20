// Update progress text width to match corpus map
$(document).ready(function(){
    $(".progress_text").css({'width':($("#korpuskart").width() +'px')});
});

$(window).on('resize', function(){
    $(".progress_text").css({'width':($("#korpuskart").width() +'px')});
});

// Position progress text relative to corpus map title
$(document).ready(function(){
    var titleEl = $("#korpuskarttittel");
    if (titleEl.length && titleEl.offset()) {
        $(".progress_text").offset({top: titleEl.offset().top + 60});
    }
});
