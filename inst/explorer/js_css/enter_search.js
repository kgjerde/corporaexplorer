$(document).keyup(function(event) {
    if ($("#search_text").is(":focus") && (event.keyCode == 13)) {
        $("#trykk").click();
    }
});
