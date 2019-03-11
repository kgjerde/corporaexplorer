

  
  if (check_valid_column_names(search_arguments$subset_custom_column,
                               session_variables$data_dok) &
          check_regexes(
                               search_arguments$subset_terms) &
      all(check_safe_search(search_arguments$subset_terms))) {

# Filtrering ved år
session_variables[[plot_mode$mode]] <-
  filtrere_korpus_tid(
    .tibble = session_variables[[plot_mode$mode]],
    search_arguments = search_arguments,
    plot_mode$mode
  )

# Filtrering ved filter-pattern hvis et slikt finnes

if (!is.null(input$subset_corpus)) {
  search_arguments$subset_search <- TRUE

  session_variables[[plot_mode$mode]] <-
    filtrere_korpus_pattern(session_variables[[plot_mode$mode]],
                            search_arguments,
                            plot_mode$mode,
                            session_variables)
  
  
  # Ekstra filtrering av data_dok ved subsetting i data_365:
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
  }
}
}
