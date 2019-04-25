shiny::observeEvent(input$trykk, {
    # Create a Progress object
    progress <- shiny::Progress$new()
    # Make sure it closes when we exit this reactive, even if there's an error
    on.exit(progress$close())
    progress$set(message = "Processing", value = 0)

    shinyjs::disable("download_txt")
    shinyjs::disable("download_zip")
    shinyjs::disable("download_html")

    if (input$year_or_date == "Year range") {
        date_1 <- paste0(input$date_slider[1], "-01-01") %>%
            as.Date
        date_2 <- paste0(input$date_slider[2], "-12-31") %>%
            as.Date
    } else if (input$year_or_date == "Date range") {
        date_1 <- input$date_calendar[1]
        date_2 <- input$date_calendar[2]
    }

    sv$subset <- subset_date(abc,
                             date_1 = date_1,
                             date_2 = date_2)

    search_arguments$case_sensitive <- input$case_sensitivity

    search_arguments$highlight_terms <- collect_highlight_terms()

    if (!is.null(input$filter_text)) {
        search_arguments$subset_terms <- collect_subset_terms()
        search_arguments$subset_thresholds <-
            collect_threshold_values(search_arguments$subset_terms)
        search_arguments$subset_custom_column <-
            collect_custom_column(search_arguments$subset_terms)
        search_arguments$subset_terms <-
            clean_terms(search_arguments$subset_terms)
    }

    # Update date inputs, making sure they remain within corpus date range
    if (input$year_or_date == "Year range") {
      updateDateRangeInput(
        session,
        "date_calendar",
        start = if (as.Date(paste0(input$date_slider[1], "-01-01")) >
          min(abc$Date)) {
          as.Date(paste0(input$date_slider[1], "-01-01"))
        } else {
          min(abc$Date)
        },
        end = if (as.Date(paste0(input$date_slider[2], "-12-31")) <
          max(abc$Date)) {
          as.Date(paste0(input$date_slider[2], "-12-31"))
        } else {
          max(abc$Date)
        }
      )
    } else if (input$year_or_date == "Date range") {
      updateSliderInput(session,
        "date_slider",
        value = c(
          lubridate::year(input$date_calendar[1]),
          lubridate::year(input$date_calendar[2])
        )
      )
    }

    if (!identical(input$filter_text, "")) {
        if (check_valid_column_names(search_arguments$subset_custom_column,
                                     sv$subset) &
            contains_only_valid_thresholds(isolate(collect_subset_terms())) &
                check_regexes(c(search_arguments$highlight_terms,
                               search_arguments$subset_terms)) &
            contains_argument(search_arguments$highlight_terms) == FALSE) {
            sv$subset <-  subset_terms(
                sv$subset,
                terms = search_arguments$subset_terms,
                threshold = search_arguments$subset_thresholds,
                custom_column = search_arguments$subset_custom_column
            )
        }
    }

    output$info <- shiny::renderText({
        # Create a Progress object
        progress <- shiny::Progress$new()
        # Make sure it closes when we exit this reactive, even if there's an error
        on.exit(progress$close())
        progress$set(message = "Processing", value = 0)
        source("./server/check_search_arguments.R", local = TRUE)

        shiny::isolate(corpus_info_text())
    })
})
