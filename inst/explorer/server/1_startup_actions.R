# Set corpus map tab title
output$korpuskarttittel <- shiny::renderText({
    "Calendar view"
})

output$korpuskart <- shiny::renderPlot({
    start_plot <-
        visualiser_korpus(
            .data = session_variables[[plot_mode$mode]],
            .width = "auto",
            matriksen = loaded_data$original_matrix[[plot_mode$mode]],
            ordvektor = NULL,
            number_of_factors = 8,
            search_arguments = search_arguments,
            modus = plot_mode$mode
        )
    session_variables$plot_build_info <-
        ggplot2::ggplot_build(start_plot)$data[[2]]
    start_plot
    
}, height = function() {
    # https://github.com/rstudio/shiny/issues/650
    input$PLOTSIZE
})
