#' Demo apps: State of the Union addresses
#'
#' Two demo apps exploring the United States Presidential State of the Union addresses.
#'   The data are provided by the
#'   \href{https://cran.r-project.org/web/packages/sotu/index.html}{sotu}
#'   package, and includes all adresses through 2016.
#'   Interrupt R to stop the application (usually by pressing Ctrl+C or Esc).
#'
#' @name demo_sotu
#' @details For details, see
#'   \url{https://kgjerde.github.io/corporaexplorer/articles/sotu.html}.
#' @return The \code{run_sotu_*} functions launch a Shiny app.
#'   The \code{create_sotu_*} functions return a \code{corporaexplorerobject}.
NULL


# Main app -- grouped by president ----------------------------------------

#' Demo app: State of the Union addresses grouped by president
#'
#' @param ... Arguments passed to run_corpus_explorer()
#' @rdname demo_sotu
#' @export
run_sotu_app <- function(...) {

    corpus <- create_sotu_app()

    run_corpus_explorer(corpus, ...)
}


#' Create "state of the union" app
#'
#' @rdname demo_sotu
#' @export
create_sotu_app <- function() {
    df <- create_sotu_df()

    corpus <- prepare_data(
        df,
        date_based_corpus = FALSE,
        grouping_variable = "president",
        columns_doc_info =
            colnames(df)[1:5],
        within_group_identifier = "year",
        tile_length_range = c(2, 10),
        use_matrix = FALSE
    )

    return(corpus)
}


# Alternative app -- grouped by decade ------------------------------------

#' Demo app: State of the Union addresses grouped by decade
#'
#' @param ... Arguments passed to run_corpus_explorer()
#' @rdname demo_sotu
#' @export
run_sotu_decade_app <- function(...) {

    corpus <- create_sotu_decade_app()

    run_corpus_explorer(corpus, ...)
}


#' Create alternative "state of the union" app, organised by decade
#'
#' @rdname demo_sotu
#' @export
create_sotu_decade_app <- function() {
    df <- create_sotu_df()

    corpus <- prepare_data(
        df,
        date_based_corpus = FALSE,
        grouping_variable = "decade",
        columns_doc_info =
            colnames(df)[1:5],
        within_group_identifier = "for_tab_title",
        tile_length_range = c(2, 10),
        use_matrix = FALSE
    )

    return(corpus)
}

# Create sotu df ----------------------------------------------------------


#' Create a data frame with State of the Union texts and metadata
#'
#' From the "sotu" package.
#'
#' @return data frame
#' @rdname demo_state_of_the_union
#' @keywords internal
create_sotu_df <- function() {

    ## Check that sotu package is installed
    if (!requireNamespace("sotu", quietly = TRUE)) {
        stop(
            'The demo app uses data from the "sotu" package. Please install it by running: install.packages("sotu")',
            call. = FALSE
        )
    }

    ## Merge data from 'sotu' package into one df
    df <- sotu::sotu_meta
    df$Text <- sotu::sotu_text %>%
        stringr::str_trim()

    ## Avoid clutter in corpus plot
    # A. Distinguish between non-consecutive terms
    df$president[97:100] <- "Grover Cleveland 1"
    df$president[105:108] <- "Grover Cleveland 2"

    # B. Get correct order of rows in data frame
        # in the cases where incumbent holds a final sotu before leaving office,
        # resulting in two sotus in one year
    presidents <- unique(df$president)
    df$president <- factor(df$president, levels = presidents)
    df <- df[order(df$president),]
    df$president <- as.character(df$president)

    ## Add decade variable for variation of app
    df$decade <- stringr::str_sub(df$year, 1, 3) %>%
        paste0("0s")

    # And add variable for informative document tab title in that app variation
    df$for_tab_title <- paste(df$president, df$year)

    return(df)
}
