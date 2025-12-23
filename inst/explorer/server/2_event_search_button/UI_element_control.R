# Scroll to top
shinyjs::runjs('window.scrollTo(0, 0);')

# Tømmer ved nytt søk
output$doc_tekst <- shiny::renderText({
    NULL
})
output$dok_vis <-
    shiny::renderPlot({
        NULL
    }, height = function() {
        1
    })
output$dag_kart <-
    shiny::renderPlot({
        NULL
    }, height = function() {
        1
    })

hide_ui("day_corpus_box")
hide_ui("document_box")

# Edit info plot legend keys UI
shinyWidgets::updateCheckboxGroupButtons(session,
                                         "edit_info_plot_legend_keys",
                                         selected = "No")
shinyjs::hideElement("edit_info_plot_legend_keys")

# Update date inputs, making sure they remain within corpus date range
# Only do this if the date inputs exist (accordion panel has been opened)
if (DATE_BASED_CORPUS == TRUE && !is.null(input$date_slider) && !is.null(input$date_calendar)) {
  if (search_arguments$time_filtering_mode == "Year range") {
    updateDateRangeInput(
      session,
      "date_calendar",
      start = if (as.Date(paste0(input$date_slider[1], "-01-01")) >
        min(loaded_data$original_data$data_dok$Date)) {
        as.Date(paste0(input$date_slider[1], "-01-01"))
      } else {
        min(loaded_data$original_data$data_dok$Date)
      },
      end = if (as.Date(paste0(input$date_slider[2], "-12-31")) <
        max(loaded_data$original_data$data_dok$Date)) {
        as.Date(paste0(input$date_slider[2], "-12-31"))
      } else {
        max(loaded_data$original_data$data_dok$Date)
      }
    )
  } else if (search_arguments$time_filtering_mode == "Date range") {
    updateSliderInput(session,
      "date_slider",
      value = c(
        lubridate::year(input$date_calendar[1]),
        lubridate::year(input$date_calendar[2])
      )
    )
  }
}

# Fjerner faner (relevant for data_dok) - only if they exist
if (session_variables$doc_tab_open == TRUE) {
  remove_tab_doc_info()
  remove_tab_doc_tekst()
  if (INCLUDE_EXTRA == TRUE) {
    remove_tab_extra()
  }
  session_variables$doc_tab_open <- FALSE
}
if (session_variables$doc_list_open == TRUE) {
  remove_tab_doc_list_tekst()
  session_variables$doc_list_open <- FALSE
}

# Setter tab-tittel på korpuskart hvis ny tittel
if (plot_mode$changed == TRUE) {
  output$korpuskarttittel <- shiny::renderText({
    corpus_map_title(plot_mode$mode)
  })
}
