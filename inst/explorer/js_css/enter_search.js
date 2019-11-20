$(document).keyup(function(event) {
    if ($("#search_text_1, #search_text_2, #search_text_3, #search_text_4, #search_text_5, #search_text_6").is(":focus") && (event.keyCode == 13)) {
        $("#search_button").click();
    }
});
