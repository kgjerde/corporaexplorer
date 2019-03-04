#' Collecting treshold values for search terms
#'
#' If user input is "search_term--\d".
#'
#' @return Numeric vector with same length as search_terms vector. NA if no
#'   treshold.
collect_treshold_values <- function(chr_vector) {
    tresholds <- stringr::str_extract(chr_vector, "--\\d+($|--)") %>%
        stringr::str_replace_all("[^\\d]", "") %>%
        as.numeric()
    return(tresholds)
}

#' Collecting custom column in which to search for search terms
#'
#' If user input is "search_term--\d".
#'
#' @return Numeric vector with same length as search_terms vector. NA if no
#'   treshold.
collect_custom_column <- function(chr_vector) {
    column <- stringr::str_extract(chr_vector, "--[^\\d].*($|--)") %>%
    stringr::str_replace_all("(--\\d+|--)", "")
    return(column)
}

#' Collecting subset/filter terms from user input
#'
#' @return Character vector.
collect_subset_terms <- function() {
    terms_subset <- input$filter_text %>%
        stringr::str_trim() %>%
        stringr::str_replace_all("(\\s){2,}", "\\1") %>%
        stringr::str_split("\n") %>%
        unlist %>%
        .[length(.) > 0] %>%
        (function(x)
            x <- x[x != ""]) %>%
        unique
    
    return(terms_subset)
}
