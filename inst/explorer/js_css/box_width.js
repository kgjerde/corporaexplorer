$(document).ready(function() {
  $(".class_day_corpus .nav-tabs-custom").css({
    'width': ($(".nav-tabs-custom").width() + 'px')
  });
});

$(document).ready(function() {
  $(".class_doc_box .nav-tabs-custom").css({
    'width': ($(".nav-tabs-custom").width() + 'px')
  });
});

$(document).ready(function(){
    $(".progress_text").css({'width':($("#korpuskart").width() +'px')});
});

$(window).on('resize', function(){
    $(".progress_text").css({'width':($("#korpuskart").width() +'px')});
});

$(document).ready(function(){
    $(".progress_text").offset({top:$("#korpuskarttittel").offset().top + 60})
});
