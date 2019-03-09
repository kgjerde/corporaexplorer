jQuery(document).ready(function($){ //wait for the document to load
        $('.class_doc_box .nav-tabs-custom').css({
            'top' : $('.class_day_corpus .nav-tabs-custom').outerHeight() + 70 + 'px' //adjust the css rule for margin-top to equal the element height - 10px and add the measurement unit "px" for valid CSS
        });
});

// From https://stackoverflow.com/a/44156191/8399819
