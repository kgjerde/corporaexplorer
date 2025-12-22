shiny::observeEvent(input$dok_vis_click, {
    # Cursor position
    musepos_dok_vis <- input$dok_vis_click
    rute_nr <- ceiling(musepos_dok_vis$x - 0.5)
    shinyjs::runjs(sprintf(
        "$('.class_doc_box .card').scrollTo('#%s', {duration: 200});",
        rute_nr
    ))
})
