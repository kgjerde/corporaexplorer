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

# Update date inputs, making sure they remain within corpus date range
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

# Fjerner faner (relevant for data_dok)
shiny::removeTab('dokumentboks', target = "document_box_title_info",
          session = shiny::getDefaultReactiveDomain())
shiny::removeTab('dokumentboks', target = "document_box_title",
          session = shiny::getDefaultReactiveDomain())

# Setter tab-tittel på korpuskart
output$korpuskarttittel <- shiny::renderText({
    if (plot_mode$mode == "data_365") {
        "Calendar view"
    } else if (plot_mode$mode == "data_dok") {
        "Document wall view"
    }
})
