if (session_variables$doc_tab_open == FALSE) {
  add_tab_doc_tekst(365)
  add_tab_doc_info(365)
  if (INCLUDE_EXTRA == TRUE) {
    add_tab_extra(365)
  }
  session_variables$doc_tab_open <- TRUE
} else if (session_variables$doc_tab_open == TRUE) {
  shiny::updateTabsetPanel(
    session,
    inputId = "dokumentboks",
    selected = 'document_box_title'
  )
}


# Setter fane-tittel
output$document_box_title <- shiny::renderText({
  paste0("Document ", min_rad, " \u2013 ", "Text")
})

# Setter fane-tittel
output$document_box_title_info <- shiny::renderText({
  paste0("Document ", min_rad, " \u2013 ", "Information")
})
