// Cmd+Enter (Mac) or Ctrl+Enter (Windows) triggers search from text areas
$(document).keydown(function(event) {
    if ($("#search_terms_area, #highlight_terms_area, #filter_text_area").is(":focus") &&
        event.keyCode === 13 &&
        (event.metaKey || event.ctrlKey)) {
        event.preventDefault();
        $("#search_button").click();
    }
});
