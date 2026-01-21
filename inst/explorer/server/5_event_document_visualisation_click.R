shiny::observeEvent(input$dok_vis_click, {
  # Cursor position
  musepos_dok_vis <- input$dok_vis_click
  rute_nr <- ceiling(musepos_dok_vis$x - 0.5)
  # Use percentage-based scrolling instead of anchors
  # This avoids inserting anchor spans that fragment text nodes
  pct <- (rute_nr - 1) / DOCUMENT_TILES * 100
  shinyjs::runjs(sprintf(
    "$('.class_doc_box .doc-scroll-container').scrollTo('%f%%', {duration: 200});",
    pct
  ))
})
