
  if (check_valid_column_names(search_arguments$subset_custom_column,
                               session_variables$data_dok) &
      check_regexes(search_arguments$subset_terms)) {
    if (all(check_safe_search(search_arguments$subset_terms))) {


# Filtering by years/dates ------------------------------------------------

if (DATE_BASED_CORPUS == TRUE) {

session_variables[[plot_mode$mode]] <-
  filtrere_korpus_tid(
    .tibble = session_variables[[plot_mode$mode]],
    search_arguments = search_arguments,
    plot_mode$mode
  )

}

# Filtering by filter pattern if present ----------------------------------

if (!is.null(input$subset_corpus)) {
  search_arguments$subset_search <- TRUE

  session_variables[[plot_mode$mode]] <-
    filtrere_korpus_pattern(session_variables[[plot_mode$mode]],
                            search_arguments,
                            plot_mode$mode,
                            session_variables)

# Ekstra filtrering av data_dok ved subsetting i data_365: ----------------

  if (plot_mode$mode == "data_365" &
      !is.null(input$subset_corpus)) {
    session_variables$data_dok <-

      filtrere_korpus_tid(
        .tibble = session_variables$data_dok,
        search_arguments = search_arguments,
        "data_dok"#plot_mode$mode
      ) %>%

      filtrere_korpus_pattern(.,
                              search_arguments,
                              "data_dok",
                              session_variables)

  # Telling the data_365 tibble which dates contain
    # at least one document with all the subset terms:
    non_empty_dates <- unique(session_variables$data_dok$Date)

    session_variables$data_365$Day_without_docs[session_variables$data_365$Date %in% non_empty_dates == FALSE] <-
      TRUE

    session_variables$data_365$ID[session_variables$data_365$Date %in% non_empty_dates == FALSE] <-
      0

  }
}

    }
  }
