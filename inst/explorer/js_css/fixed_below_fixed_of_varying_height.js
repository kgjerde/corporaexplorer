jQuery(document).ready(function($){ //wait for the document to load
        $('.ost .nav-tabs-custom').css({
            'top' : $('.follow_scroll .nav-tabs-custom').outerHeight() + 70 + 'px' //adjust the css rule for margin-top to equal the element height - 10px and add the measurement unit "px" for valid CSS
        });
});

// From https://stackoverflow.com/a/44156191/8399819
