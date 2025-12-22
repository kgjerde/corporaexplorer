output$time_filtering_ui <- shiny::renderUI({

  if (DATE_BASED_CORPUS == TRUE) {

    shiny::tagList(
      shinyWidgets::radioGroupButtons(
        inputId = "years_or_dates",
        label = NULL,
        choices = c("Year range", "Date range"),
        justified = TRUE,
        size = "sm"
      ),

      shiny::conditionalPanel(
        condition = "input.years_or_dates == 'Year range'",
        shiny::sliderInput(
          "date_slider",
          label = NULL,
          min = min(loaded_data$original_data$data_dok$Year_),
          max = max(loaded_data$original_data$data_dok$Year_),
          value = range(loaded_data$original_data$data_dok$Year_),
          sep = "",
          ticks = FALSE
        )
      ),

      shiny::conditionalPanel(
        condition = "input.years_or_dates == 'Date range'",
        shiny::dateRangeInput(
          "date_calendar",
          label = NULL,
          weekstart = 1,
          start = min(loaded_data$original_data$data_dok$Date),
          end = max(loaded_data$original_data$data_dok$Date),
          min = min(loaded_data$original_data$data_dok$Date),
          max = max(loaded_data$original_data$data_dok$Date)
        )
      )
    )

  }

})
