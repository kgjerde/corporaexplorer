#' Check if vector contains any invalid treshold argument ("--\\d+")
#' 
#' @param chr_vector Unparsed terms input
#' @return Logical
check_valid_tresholds <- function(chr_vector) {
    chr_vector <- stringr::str_extract(chr_vector, "--\\d.*($|--)")
    chr_vector <- chr_vector[!is.na(chr_vector)]
    return(all(stringr::str_detect(chr_vector, "--\\d+($|--)")))
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

#' Checking if valid regex search
#'
#' @param patterns 
#'
#' @return Logical
check_regexes <- function(patterns) {
    patterns[is.null(patterns)] <-
        "OK"  # To deal with subset_terms == NULL TODO dirty hack
    if (USE_ONLY_RE2R == TRUE) {
        tryCatch(
            is.integer(re2r::re2_count("esel", patterns)),
            error = function(e)
                FALSE
        )
    } else if (USE_ONLY_RE2R == FALSE) {
        tryCatch(
            is.integer(stringr::str_count("esel", patterns)),
            error = function(e)
                FALSE
        )
    }
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

#' Check if coustom columns, treshold, regex, and length are all OK
#'
#' No params yet.
#'
#' @return Logical
check_all_input <- function() {
    all_terms <- c(collect_highlight_terms())
    if (!is.null(input$subset_corpus)) {
        all_terms <- c(all_terms, collect_subset_terms())
    }
    
    kolonner <- collect_custom_column(all_terms)
    return(
        all(
            check_valid_column_names(kolonner, session_variables$data_dok),
            check_valid_tresholds(all_terms),
            check_regexes(clean_terms(all_terms)),
            check_search_term_length(all_terms)
        )
    )
}
