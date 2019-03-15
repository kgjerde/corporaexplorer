if (length(min_rad) > 0) {
  if (nrow(data_day) > 0) {
    make_clickable_ui(".day_map")

    session_variables$data_day <- data_day

    esel <-

      visualiser_korpus(
        session_variables$data_day,
        search_arguments = search_arguments,
        "auto",
        matriksen = loaded_data$original_matrix$data_dok,
        ordvektor = loaded_data$ordvektorer$data_dok,
        number_of_factors = 4,
        doc_df = session_variables$data_dok,
        modus = "day"
      )

    session_variables$plotinfo_dag <-
      ggplot2::ggplot_build(esel)$data[[2]]

    session_variables$day_plot_height <- (length(unique(session_variables$plotinfo_dag$ymax)) * 20) + 15

    output$dag_kart <- shiny::renderPlot({
      esel
    },
    height =
      function(x) {
        session_variables$day_plot_height
      }
    )
  } else if (nrow(data_day) == 0) {
    session_variables$day_plot_height <- EMPTY_DAY_PLOT_HEIGHT
    make_unclickable_ui(".day_map")
    output$dag_kart <- shiny::renderPlot({
      ggplot2::ggplot() +
        ggplot2::geom_blank() +
        ggplot2::theme_classic()
    },
    height =
      function(x) {
        session_variables$day_plot_height
      }
    )
  }
}
