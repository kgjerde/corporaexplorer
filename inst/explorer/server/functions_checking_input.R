#' Check if vector contains any invalid threshold argument ("--\\d+")
#'
#' @param chr_vector Unparsed terms input
#' @return Logical
check_valid_thresholds <- function(chr_vector) {
  chr_vector <- stringr::str_extract(chr_vector, "--\\d.*($|--)")
  chr_vector <- chr_vector[!is.na(chr_vector)]
  return(all(stringr::str_detect(chr_vector, "--\\d+($|--)")))
}

validate_thresholds <- function(terms) {
  shiny::validate(shiny::need(
    check_valid_thresholds(isolate(
      terms
    )),
    paste(
      '\nThreshold argument invalid. Make sure it contains only numbers, e.g. "--4".'
    )
  ))
}

#' Check if vector contains any invalid column argument (not in df)
#'
#' @param chr_vector terms input
#' @param df data frame with columns to check
#' @return Logical (TRUE if all is OK)
check_valid_column_names <- function(chr_vector, df) {
  chr_vector <- chr_vector %>%
    .[!is.na(.)]
  return(all(chr_vector %in% colnames(df)))
}

validate_column_names <- function() {
  shiny::validate(shiny::need(
    check_valid_column_names(
      c(
        search_arguments$custom_column,
        search_arguments$subset_custom_column
      ),
      session_variables$data_dok
    ),
    paste("\nMake sure to specify only variables present in the corpus.")
  ))
}

#' Checking if valid regex search
#'
#' @param patterns
#'
#' @return Logical
check_regexes <- function(patterns) {
  patterns[is.null(patterns)] <-
    "OK" # To deal with subset_terms == NULL TODO dirty hack
  if (USE_ONLY_RE2 == TRUE) {
    tryCatch(
      is.integer(re2::re2_count("esel", patterns)),
      error = function(e) {
        FALSE
      }
    )
  } else if (USE_ONLY_RE2 == FALSE) {
    tryCatch(
      is.integer(stringr::str_count("esel", patterns)),
      error = function(e) {
        FALSE
      }
    )
  }
}

validate_regexes <- function() {
  shiny::validate(shiny::need(
    check_regexes(c(
      unlist(search_arguments$terms_highlight),
      # TODO dirty hack because empty search_arguments$terms_highlight) is list() and messes up the concatenation
      unlist(search_arguments$subset_terms)
    )),
    paste("\nInvalid regular expression. Please modify your search.")
  ))
}

#' Check if any one term exceeds set length limit
#'
#' @param terms
#' @param character_limit
#'
#' @return Logical (TRUE if all is OK)
check_search_term_length <- function(terms, character_limit = CHARACTER_LIMIT) {
  return(!any(nchar(terms) > character_limit, na.rm = TRUE))
}

validate_search_term_length <- function() {
  shiny::validate(shiny::need(
    check_search_term_length(
      c(
        search_arguments$terms_highlight,
        search_arguments$subset_terms
      )
    ),
    paste(
      "\nSearch expression exceeds",
      CHARACTER_LIMIT,
      "character limit."
    )
  ))
}

#' Check if coustom columns, threshold, regex, and length are all OK
#'
#' No params yet.
#'
#' @return Logical
check_all_input <- function() {
  all_terms <- search_arguments$raw_highlight_terms
  if (search_arguments$subset_search == TRUE) {
    all_terms <- c(all_terms, search_arguments$raw_subset_terms)
  }
  if (length(all_terms) > 0) {
    kolonner <- collect_custom_column(all_terms)
    return_value <-
      all(
        check_valid_column_names(kolonner, session_variables$data_dok),
        check_valid_thresholds(all_terms),
        check_regexes(clean_terms(all_terms)),
        check_search_term_length(all_terms)
      )
    if (return_value == TRUE) {
      return_value <- all(check_safe_search(all_terms))
    }
    return(return_value)
  } else {
    return(TRUE)
  }
}


#' Check is patterns potentially can return extremely many hits
#'
#' @param patterns Character vector
check_safe_search <- Vectorize(
  function(pattern) {
    if (SAFE_SEARCH == TRUE) {
      test_text <-
        "This is a very short ASCII text.\nА это краткий не-ascii текст."
      len <- nchar(test_text)
      ratio <- 0.1
      if (can_use_re2(pattern)) {
        return(re2::re2_count(test_text, pattern) / len < ratio)
      } else {
        return(stringr::str_count(test_text, pattern) / len < ratio)
      }
    } else {
      return(TRUE)
    }
  },
  USE.NAMES = FALSE
)

validate_safe_search <- function() {
  shiny::validate(shiny::need(
    all(check_safe_search(
      c(
        search_arguments$terms_highlight,
        search_arguments$subset_terms
      )
    )),
    paste(
      "\nThe search patterns will result in an enormous amount of hits or the search will run for a very long time, potentially infinitely.

If this is something you want, set 'allow_unreasonable_patterns' in 'explore()' to 'TRUE'."
    )
  ))
}

#' Validate if number of docs in wall view exceeds allowed
#'
validate_max_docs_in_wall <- function() {
  shiny::validate(shiny::need(
    (nrow(session_variables[[plot_mode$mode]]) > MAX_DOCS_IN_WALL_VIEW &
      plot_mode$mode == "data_dok") ==
      FALSE,
    paste(
      "\nCorpus map too large. Filter corpus or switch to calendar view if available.\n\n",
      "Alternatively, specify 'max_docs_in_wall_view'",
      "in the 'plot_options' argument in the call to 'explore()'."
    )
  ))
}
