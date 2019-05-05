shiny::observeEvent(input$dok_vis_click, {
    # Cursor position
    musepos_dok_vis <- input$dok_vis_click
    rute_nr <- ceiling(musepos_dok_vis$x - 0.5)
    shinyjs::runjs(sprintf(
        "$('.boxed_doc_%s').scrollTo('#%s', duration = 200);",
        plot_mode$mode,
        rute_nr
    ))
})
