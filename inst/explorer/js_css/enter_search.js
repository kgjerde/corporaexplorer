$(document).keyup(function(event) {
    if ($("#search_text_1").is(":focus") && (event.keyCode == 13)) {
        $("#search_button").click();
    }
});
