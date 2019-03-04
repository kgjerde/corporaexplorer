output$korpuskart <- renderPlot({

source("./server/2_event_search_button/check_search_arguments.R", local = TRUE)
    
    shiny::outputOptions(
        output,
        name = "korpuskart",
        priority = 10,
        suspendWhenHidden = FALSE
    )
    
    # TODO: algoritme må forbedres!
    value_for_slider = (length(unique(session_variables[[plot_mode$mode]][["Year"]])) * 90)
    
    value_for_slider <-
        value_for_slider * length(search_arguments$search_terms) * 0.75
    
    value_for_slider <- ceiling(value_for_slider)
    # TODO Problem med omigjen-rendering ikke endelig løst
    # av commit 2b6ca83
    shiny::updateSliderInput(
        session,
        "PLOTSIZE",
        label = NULL,
        value = value_for_slider,
        min = NULL,
        max = NULL,
        step = NULL
    )
    
    
    plot_fase_1 <-
        visualiser_korpus(
            session_variables[[plot_mode$mode]],
            doc_df = session_variables$data_dok,
            search_arguments = search_arguments,
            modus = plot_mode$mode
        )
    
    session_variables$plot_build_info <-
        ggplot2::ggplot_build(plot_fase_1)$data[[2]]
    
    plot_fase_1
    
}, #height = function() {  # https://github.com/rstudio/shiny/issues/650
height =
    function(x) {
        input$PLOTSIZE
    })
