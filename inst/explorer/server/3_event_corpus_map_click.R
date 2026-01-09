shiny::observeEvent(input$plot_click, {
  # Identify which row in df the click position refers to
  min_rad <- finn_min_rad(input$plot_click, session_variables$plot_build_info)
  select_corpus_row(min_rad)
})
