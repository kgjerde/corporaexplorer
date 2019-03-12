#' Launching Shiny app for exploration of text collection on Shiny Server
#'
#'
#' @param corpus_object A corpusexploration object created by
#'   \code{\link[corpusexplorationr]{prepare_data}}.
#' @param use_matrix Logical. If the corpusexplorationobject contains a document
#'   term matrix, should it be used for searches? (See
#'   \code{\link[corpusexplorationr]{prepare_data}}.)
#' @param regex_engine Specify regular expression engine to be used: \itemize{
#'   \item `default`: use the \code{re2r} package
#'   (\url{https://github.com/qinwf/re2r}) for simple searches and the
#'   \code{stringr} package (\url{https://github.com/tidyverse/stringr} for
#'   complex regexes (i.e. when special regex characters are used). \item
#'   `stringr`: use \code{stringr} for all searches. \item `re2r`: use
#'   \code{re2r} for all searches.}
#' @param optional_info Logical. If \code{TRUE}, information about search method
#'   (regex engine and whether the search was conducted in the document term
#'   matrix or in the full text documents).
#' @param allow_unreasonable_patterns Logical. If \code{FALSE}, the app will
#'   not allow patterns that will result in an enormous amount of hits or will
#'   lead to a very slow search. (Examples of such patterns will include
#'   '\code{.}' and '\code{\\b}'.)
#' @param ... Other arguments passed to \code{\link[shiny]{runApp}} in the Shiny
#'   package.
#' @keywords internal
#' @rawNamespace import(data.table, except = ":=")
#' @import rlang
#' @examples
#' # Constructing test data frame:
#' dates <- as.Date(paste(2011:2020, 1:10, 21:30, sep = "-"))
#' texts <- paste0(
#'   "This is a document about ", month.name[1:10], ". ",
#'   "This is not a document about ", rev(month.name[1:10]), "."
#' )
#' titles <- paste("Text", 1:10)
#' test_df <- tibble::tibble(Date = dates, Text = texts, Title = titles)
#'
#' # Converting to corpusexploration object:
#' corpus <- prepare_data(test_df, corpus_name = "Test corpus")
#' \dontrun{
#' # Running exploration app:
#' run_corpus_exploration(corpus)
#'
#' # Running app to extract documents:
#' run_document_extractor(corpus)
#' }
run_server <- function(corpus_object,
                                use_matrix = TRUE,
                                regex_engine = c(
                                  "default",
                                  "stringr",
                                  "re2r"
                                ),
                                optional_info = FALSE,
                                allow_unreasonable_patterns = FALSE,
                                ...) {
  app <- system.file("explorer", "app.R", package = "corpusexplorationr")
  if (app == "") {
    stop("Could not find directory. Try re-installing `corpusexplorationr`.",
      call. = FALSE
    )
  }

  if ("package:corpusexplorationr" %in% search() == FALSE) {
    stop(
      "Load 'corpusexplorationr' by running 'library(corpusexplorationr)', then run 'run_corpus_explorer()'.",
      call. = FALSE
    )
  }

  if (class(corpus_object) != "corpusexplorationobject") {
    stop("'data' is not a corpusexplorationobject",
      call. = FALSE
    )
  }


  if (!is.logical(optional_info)) {
    stop(sprintf("Invalid '%s' argument.", "optional_info"),
      call. = FALSE
    )
  }

  if (!is.logical(allow_unreasonable_patterns)) {
    stop(sprintf("Invalid '%s' argument.", "allow_unreasonable_patterns"),
      call. = FALSE
    )
  }

  if (identical(regex_engine, c(
    "default",
    "stringr",
    "re2r"
  ))) {
    regex_engine <- "default"
  }

  if (!(regex_engine %in% c(
    "default",
    "stringr",
    "re2r"
  ))) {
    stop(sprintf("Invalid '%s' argument.", "regex_engine"),
      call. = FALSE
    )
  }

  shiny::shinyOptions("corpusexplorationr_SERVER" = TRUE)

  shiny::shinyOptions("corpusexplorationr_optional_info" = optional_info)
  shiny::shinyOptions("corpusexplorationr_regex_engine" = regex_engine)
  shiny::shinyOptions("corpusexplorationr_use_matrix" = use_matrix)
  shiny::shinyOptions("corpusexplorationr_allow_unreasonable_patterns" = allow_unreasonable_patterns)

  data <- as.character(substitute(corpus_object))
  shiny::shinyOptions("corpusexplorationr_data" = data)

  message(sprintf(
    "Exploring %s document%s",
    nrow(corpus_object$original_data$data_dok),
    if (nrow(corpus_object$original_data$data_dok) != 1) "s" else ""
  ))

  return(source(app, local = TRUE)$value)
}
