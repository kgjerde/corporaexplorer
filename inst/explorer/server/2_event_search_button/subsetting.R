
# Sidebar checkbox filtering, if any --------------------------------------

# Checking for presence of checkboxes
if (!is.null(input$subset_corpus)) {
  if (!is.null(UI_FILTERING_CHECKBOXES)) {

    for (i in seq_along(UI_FILTERING_CHECKBOXES$column_names)) {
      # Do nothing if every box checked
      if (!all(UI_FILTERING_CHECKBOXES$values[[i]] %in% input[[paste0("type_", i)]])) {
      # If some unchecked, filter:
        session_variables$data_dok <-
          session_variables$data_dok[
            session_variables$data_dok[[UI_FILTERING_CHECKBOXES$column_names[i]]] %in% input[[paste0("type_", i)]],
          ]
      }
    }
  }
}

# Extra -------------------------------------------------------------------
if (INCLUDE_EXTRA == TRUE) {
  search_arguments$subset_search <- !is.null(input$extra_fields)
  if (search_arguments$subset_search == TRUE) {
    if (stringi::stri_isempty(input$magic_text_area) == FALSE) {
      # TODO better "collection" of patterns
      extra_subset_terms <- input$magic_text_area %>%
        stringr::str_split("\n") %>%
        unlist(use.names = FALSE) %>%
        .[!stringi::stri_isempty(.)]

      if (cx_validate_input(extra_subset_terms) == TRUE) {
        for (pattern in extra_subset_terms) {
          session_variables$data_dok <-
            cx_extra_subset(
              pattern,
              session_variables$data_dok,
              search_arguments$case_sensitive,
              session_variables$data_dok$ID
            )
        }

        # If validation fails:
      } else {
        shinyWidgets::sendSweetAlert(
          session = session,
          title = "Warning",
          text = "Input in 'Sentence based filtering' box is invalid and ignored.",
          type = "warning"
        )
      }
    }
  }
}

# And then the rest of the sidebar input ----------------------------------

 if (check_valid_column_names(search_arguments$subset_custom_column,
                               session_variables$data_dok) &
      # TODO dirty hack because open but empty filter corpus field in app is list(),
      # which fails the regex check
      # (but NULL, i.e. `unlist(list())` passes the regex check)
      # (same dirty hack as other TODO):
      check_regexes(unlist(search_arguments$subset_terms))) {
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
}

# Ekstra filtrering av data_dok ved subsetting i data_365: ----------------

  if (plot_mode$mode == "data_365") {
      if (search_arguments$subset_search == TRUE | search_arguments$subset_search == TRUE) {

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
