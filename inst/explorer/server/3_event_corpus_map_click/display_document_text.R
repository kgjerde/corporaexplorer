output$doc_tekst <- shiny::renderText({
  display_document(
    session_variables[[plot_mode$mode]]$Text_original_case[min_rad],
    search_arguments
  )
})

if (INCLUDE_FIND_IN_TEXT) {
  shinyjs::runjs(sprintf(
    "setTimeout(function() { window.initDocFind(%s); }, 200);",
    jsonlite::toJSON(search_arguments$terms_highlight, auto_unbox = FALSE)
  ))
}
