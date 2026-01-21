if (session_variables$doc_tab_open == TRUE) {
  remove_tab_doc_tekst()
  remove_tab_doc_info()
  if (INCLUDE_EXTRA == TRUE) {
    remove_tab_extra()
  }

  session_variables$doc_tab_open <- FALSE
}

if (session_variables$doc_list_open == FALSE) {
  add_tab_doc_list_tekst(365)

  session_variables$doc_list_open <- TRUE
} else if (session_variables$doc_list_open == TRUE) {
  shiny::updateTabsetPanel(
    session,
    inputId = "dokumentboks",
    selected = 'document_list_title'
  )
}

# Viser dag_kart og dokumentboks
show_ui("day_corpus_box")
show_ui("document_box")

# Setter tab-tittel
output$document_list_title <- shiny::renderText({
  "Document list"
})


# Setter boks-tittel
output$title <- shiny::renderText({
  format_date(session_variables[[plot_mode$mode]]$Date[min_rad])
})

# Setter boks-tittel
output$document_box_title <- shiny::renderText({
  "Document list"
})
