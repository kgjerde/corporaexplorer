# Set corpus map tab title
output$korpuskarttittel <- shiny::renderText({
    corpus_map_title(plot_mode$mode)
})

# Hidden at start-up so it displays in correct position rather than jumping first
shinyjs::show(selector = ".progress_text")

output$korpuskart <- shiny::renderPlot({

    validate_max_docs_in_wall()

    start_plot <-
        visualiser_korpus(
            df = session_variables[[plot_mode$mode]],
            .width = "auto",
            matriksen = loaded_data$original_matrix[[plot_mode$mode]],
            ordvektor = NULL,
            number_of_factors = NUMBER_OF_FACTORS,
            search_arguments = search_arguments,
            modus = plot_mode$mode
        )

    # Identifying the coordinates for the rectangles around date/document
        # Depends on plot mode and # of search terms.
    index_of_main_grid_rects <- dplyr::case_when(
        plot_mode$mode == "data_365" ~ as.integer(length(ggplot2::ggplot_build(start_plot)$data) - 2),
        plot_mode$mode == "data_dok" ~ as.integer(length(ggplot2::ggplot_build(start_plot)$data))
    )

    session_variables$plot_build_info <-
        ggplot2::ggplot_build(start_plot)$data[[index_of_main_grid_rects]]

    start_plot

}, height = function() {
    # https://github.com/rstudio/shiny/issues/650
    session_variables$plot_size
})

