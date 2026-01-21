# Document information tab ------------------------------------------------
output$doc_info <- shiny::renderText({
  display_document_info(session_variables$data_dok, min_rad)
})
