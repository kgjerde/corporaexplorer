# Calculating new plot height
session_variables$plot_size <-
  plot_size(
    session_variables[[plot_mode$mode]],
    calendar_mode = plot_mode$mode == "data_365",
    number_of_search_terms = length(search_arguments$search_terms)
  )

# Update plot size input
shiny::updateSliderInput(
  session,
  "PLOTSIZE",
  label = NULL,
  value = session_variables$plot_size,
  min = NULL,
  max = session_variables$plot_size * 2,
  step = NULL
)

# Hide "progress text" in case rendering stops at arguments check
shinyjs::hide(selector = ".progress_text")

# Plot output
output$korpuskart <- renderPlot(
  {
    # Arguments check
    source("./server/2_event_search_button/check_search_arguments.R", local = TRUE)

    # Show "progress text" again (will remain hidden under the plot)
    shinyjs::show(selector = ".progress_text")

    # The plot itself
    plot_fase_1 <-
      visualiser_korpus(
        session_variables[[plot_mode$mode]],
        doc_df = session_variables$data_dok,
        search_arguments = search_arguments,
        modus = plot_mode$mode
      )

    # Identifying the coordinates for the rectangles around date/document
    # Depends on plot mode and # of search terms.
    index_of_main_grid_rects <- dplyr::case_when(
      plot_mode$mode == "data_365" ~ as.integer(length(ggplot2::ggplot_build(plot_fase_1)$data) - 2),
      plot_mode$mode == "data_dok" ~ as.integer(length(ggplot2::ggplot_build(plot_fase_1)$data))
    )

    # Plot info for use for interactivity with plot
    session_variables$plot_build_info <-
      ggplot2::ggplot_build(plot_fase_1)$data[[index_of_main_grid_rects]]

    # Returning the plot object
    plot_fase_1

  }, # https://github.com/rstudio/shiny/issues/650
  height =
    function(x) {
      session_variables$plot_size
    }
)
