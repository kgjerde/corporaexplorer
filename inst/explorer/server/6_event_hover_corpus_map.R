output$hover_info <- shiny::renderUI({
  if (is.null(input$plot_hover)) {
    return(NULL)
  }

  min_rad <-
    finn_min_rad(input$plot_hover, session_variables$plot_build_info)
  # TODO input$plot_hover repetering

  # Tooltip position calculation --------------------------------------------
  hover <- input$plot_hover

  # calculate point position INSIDE the image as percent of total dimensions
  # from left (horizontal) and from top (vertical)
  left_pct <-
    (hover$x - hover$domain$left) / (hover$domain$right - hover$domain$left)
  top_pct <-
    (hover$domain$top - hover$y) / (hover$domain$top - hover$domain$bottom)

  # calculate distance from left and bottom side of the picture in pixels
  left_px <-
    hover$range$left / hover$img_css_ratio$x + left_pct * (hover$range$right / hover$img_css_ratio$x - hover$range$left / hover$img_css_ratio$x)
  top_px <-
    hover$range$top / hover$img_css_ratio$y + top_pct * (hover$range$bottom / hover$img_css_ratio$y - hover$range$top / hover$img_css_ratio$y)

  if (top_px > (session$clientData$output_korpuskart_height - 200)) {
    top_px <- session$clientData$output_korpuskart_height - 200
  } # TODO: må gjøres bedre. Foreløpig hack for å unngå problemer når tooltip under bunn av vindu

  if (top_px < 0) {
    top_px <- 0
  } # TODO: må gjøres bedre. Foreløpig hack for å unngå problemer når tooltip over topp av vindu

  # Tooltip style and defining position -------------------------------------
  style <-
    paste0(
      "position:absolute; z-index:100; background-color: rgba(245, 245, 245, 0.85); ",
      "left:",
      left_px + 2,
      "px; top:",
      top_px + 2,
      "px;",
      "font-size: 14px;"
    )


  # Tooltip text ------------------------------------------------------------
  if (plot_mode$mode == "data_365") {
    if (length(min_rad) > 0) {
      if (session_variables[[plot_mode$mode]]$Invisible_fake_date[min_rad] == FALSE) {
        if (length(min_rad) != 0) {
          shiny::wellPanel(
            style = style,
            shiny::p(shiny::HTML(
              paste0(
                "<b> Date: </b>",
                format_date(session_variables[[plot_mode$mode]]$Date[min_rad]),
                "<br/>",
                "<b> Documents this day: </b>",
                length(
                  which(
                    session_variables$data_dok$Date == session_variables[[plot_mode$mode]]$Date[min_rad]
                  )
                ),
                "<br/>"
              )
            ))
          )
        }
      }
    }
  } else if (plot_mode$mode == "data_dok") {
    if (length(min_rad) > 0) {
      if (DATE_BASED_CORPUS) {
        shiny::wellPanel(
          style = style,
          shiny::p(shiny::HTML(
            paste0(
              "<b> Date: </b>",
              format_date(session_variables[[plot_mode$mode]]$Date[min_rad]),
              "<br/>"
            )
          ))
        )
      } else if (DATE_BASED_CORPUS == FALSE) {
        shiny::wellPanel(
          style = style,
          shiny::p(shiny::HTML(
            doc_title_non_date_based_corpora(min_rad)
          ))
        )
      }
    }
  }
})
