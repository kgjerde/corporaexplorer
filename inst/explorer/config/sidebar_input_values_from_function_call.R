# Default sidebar input values
input_arguments <- list(
  search_terms = NA, # TODO this works, but I would like something more intuitive
  highlight_terms = "",
  filter_terms = "",
  case_sensitivity = FALSE,
  extra_chart_terms = "",
  extra_subset_terms = ""
)

# Receiving input from function arguments
# If no arguments are passed, the value here is `list()`
arguments <- shiny::getShinyOption("corporaexplorer_input_arguments")

# Replacing default input values with values passed from function call (if any)
input_arguments[names(arguments)] <- arguments

# Determine input values that need to be derived from those given in function call
input_arguments_derived <- list(
  number_of_search_terms = if (is.null(arguments$search_terms)) {
    1
  } else {
    length(input_arguments$search_terms)
  },
  filter_terms = paste(input_arguments$filter_terms, collapse = "\n"),
  filter_corpus_button = if (identical(input_arguments$filter_terms, "")) {
    NULL
  } else {
    "Yes"
  },
  highlight_terms = paste(input_arguments$highlight_terms, collapse = "\n"),
  more_terms_button = if (identical(input_arguments$highlight_terms, "")) {
    NULL
  } else {
    "Yes"
  }
)

if (INCLUDE_EXTRA == TRUE) {
  input_arguments_derived$extra_chart_terms <- paste(
    input_arguments$extra_chart_terms,
    collapse = "\n"
  )
  input_arguments_derived$extra_subset_terms <- paste(
    input_arguments$extra_subset_terms,
    collapse = "\n"
  )

  input_arguments_derived$extra_fields <-
    if (
      identical(input_arguments$extra_chart_terms, "") &
        identical(input_arguments$extra_subset_terms, "")
    ) {
      NULL
    } else {
      "Yes"
    }
}
