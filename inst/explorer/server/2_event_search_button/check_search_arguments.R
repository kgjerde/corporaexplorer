if (search_arguments$all_ok == FALSE) {
  validate_search_term_length()
  validate_regexes()
  validate_safe_search()

  validate_thresholds(isolate(search_arguments$raw_highlight_terms))

  if (search_arguments$subset_search == TRUE) {
    validate_thresholds(isolate(search_arguments$raw_subset_terms))
  }

  validate_column_names()
}

shiny::validate(shiny::need(
  nrow(session_variables$data_dok) != 0,
  paste("\nThe filtered corpus does not contain any documents.")
))

validate_max_docs_in_wall()

if (INCLUDE_EXTRA == TRUE) {
  cx_shiny_validate(search_arguments$extra_chart_terms)
}
