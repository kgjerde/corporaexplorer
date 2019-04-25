#' Collecting search terms from user input
#'
#' @return Character vector.
collect_highlight_terms_1 <- function() {
    terms <- c(
        shiny::isolate(input$search_text),
        shiny::isolate(input$area_2),
        shiny::isolate(input$area_3),
        shiny::isolate(input$area_4),
        shiny::isolate(input$area_5),
        shiny::isolate(input$area_6)
    )[seq_len(shiny::isolate(input$antall_linjer))] %>%
        stringr::str_trim() %>%
        stringr::str_replace_all("(\\s){2,}", "\\1") %>%
        (function(x)
            x <- x[x != ""]) %>%
        unique
    if(length(terms) == 0){
        terms <- ""
    }

    if (search_arguments$case_sensitive == FALSE) {
        terms <- stringr::str_to_lower(terms)
    }

    return(terms)
}

#' Collecting highlight terms from user input
#'
#' @return Character vector.
collect_highlight_terms <- function() {
    if (is.null(isolate(input$more_terms_button))) {
        # avgjørende at is.null-varianten kommer først i if-statementet!
        terms_highlight <- collect_highlight_terms_1()
    }   else if (isolate(input$more_terms_button == 'Yes')) {
        terms_highlight <- isolate(input$area) %>%
            stringr::str_trim() %>%
            stringr::str_replace_all("(\\s){2,}", "\\1") %>%
            stringr::str_split("\n") %>%
            unlist %>%
            .[length(.) > 0] %>%
            unique

        terms_highlight <-
            c(collect_highlight_terms_1(), terms_highlight[terms_highlight != ""]) #%>%
           # unique  # TODO blr ikke unique-s hvis hører til ulike
                    # custom_columns
    }
    terms_highlight <-
        terms_highlight[terms_highlight != ""]

    return(terms_highlight)
}

#' Collecting threshold values for search terms
#'
#' If user input is "search_term--\d".
#'
#' @return Numeric vector with same length as search_terms vector. NA if no
#'   threshold.
collect_threshold_values <- function() {
    thresholds <- stringr::str_extract(search_arguments$search_terms, "--\\d*$") %>%
        stringr::str_replace("--", "") %>%
        as.numeric()
    return(thresholds)
}


#' Removing "threshold argument" from search term
#'
#' @param terms Character vector.
#'
#' @return "Cleaned" character vector.
clean_terms <- function(terms) {
    if (search_arguments$case_sensitive == FALSE) {
        terms <- stringr::str_to_lower(terms)
    }
    return(stringr::str_replace(terms, "--.*$", ""))
}

#' Check if vector contains any "argument" ("--")
#'
#' Purpose: make user aware that highlight terms cannot contain arguments.
#'
#' @return Logical
contains_argument <- function(chr_vector) {
    return(any(stringr::str_detect(chr_vector, "--")))
}

#' Check if vector contains any invalid threshold argument ("--\\d+")
#'
#' Purpose: make user aware that highlight terms cannot contain arguments.
#'
#' @param chr_vector Unparsed subset_terms input
#' @return Logical
contains_only_valid_thresholds <- function(chr_vector) {
    chr_vector <- stringr::str_extract(chr_vector, "--\\d.*($|--)")
    chr_vector <- chr_vector[!is.na(chr_vector)]
    return(all(stringr::str_detect(chr_vector, "[^\\d-]") == FALSE))
}


#' Check if all column arguments correspond to existing columns
#'
#' @param chr_vector A character vector of columns
#' @param df The data frame with column names
#'
#' @return Logical.
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
    # if (USE_ONLY_RE2R == TRUE) {
    #     tryCatch(
    #         is.integer(re2r::re2_count("esel", patterns)),
    #         error = function(e)
    #             FALSE
    #     )
    # } else if (USE_ONLY_RE2R == FALSE) {
        tryCatch(
            is.integer(stringr::str_count("esel", patterns)),
            error = function(e)
                FALSE
        )
    # }
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
        if (search_arguments$case_sensitive == FALSE) {
            terms_subset <- stringr::str_to_lower(terms_subset)
        }
        return(terms_subset)
}

#' Check that there are terms to highlight
#'
#' @return Logical
highlight_terms_exist <- function() {
    if (length(search_arguments$highlight_terms) > 0) {
        if (!is.na(search_arguments$highlight_terms)) {
            return(TRUE)
        }
    }
    return(FALSE)
}
