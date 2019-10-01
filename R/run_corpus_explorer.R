#' Launching Shiny app for exploration of text collection
#'
#' Launch Shiny app for exploration of text collection. Interrupt R to stop the
#' application (usually by pressing Ctrl+C or Esc).
#'
#' @param corpus_object A corporaexplorer object created by
#'   \code{\link[corporaexplorer]{prepare_data}}.
#' @param use_matrix Logical. If the corporaexplorerobject contains a document
#'   term matrix, should it be used for searches? (See
#'   \code{\link[corporaexplorer]{prepare_data}}.)
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
#' @param ui_options List. Specify custom app settings (see example below).
#'   Currently available:
#' \itemize{
#'     \item \code{MAX_DOCS_IN_WALL_VIEW}. Integer specifying the maximum number
#'     of documents to be rendered in the 'document wall' view.
#'     Default value is 12000.
#'     \item \code{font_size}. Character string specifying font size in
#'     document viww,
#'     e.g. \code{"10px"}
#'     }
#' @param search_input List. Gives the opportunity to pre-populate
#'   the following sidebar fields (see example below):
#' \itemize{
#'     \item \code{search_terms}: The 'Term(s) to chart and highlight' field.
#'     Character vector with maximum length 5.
#'     \item \code{highlight_terms}: The 'Additional terms for text highlighting' field.
#'     Character vector.
#'     \item \code{filter_terms}: The 'Filter corpus?' field. Character vector.
#'     \item \code{case_sensitivity}: Should the 'Case sensitive search' box
#'     be checked? Logical.
#'     }
#' @param ... Other arguments passed to \code{\link[shiny]{runApp}} in the Shiny
#'   package.
#' @export
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
#' # Converting to corporaexplorerobject:
#' corpus <- prepare_data(test_df, corpus_name = "Test corpus")
#'
#' if(interactive()){
#' # Running exploration app:
#' run_corpus_explorer(corpus)
#' run_corpus_explorer(corpus,
#'                     ui_options = list(MAX_DOCS_IN_WALL_VIEW = 12001),
#'                     search_input = list(search_terms = c("Tottenham", "Spurs")))
#'
#' # Running app to extract documents:
#' run_document_extractor(corpus)
#' }
run_corpus_explorer <- function(corpus_object,
                                use_matrix = TRUE,
                                regex_engine = c(
                                  "default",
                                  "stringr",
                                  "re2r"
                                ),
                                optional_info = FALSE,
                                allow_unreasonable_patterns = FALSE,
                                ui_options = list(),
                                search_input = list(),
                                ...) {
  app <- system.file("explorer", "app.R", package = "corporaexplorer")
  if (app == "") {
    stop("Could not find directory. Try re-installing `corporaexplorer`.",
      call. = FALSE
    )
  }

  if ("package:corporaexplorer" %in% search() == FALSE) {
    stop(
      "Load 'corporaexplorer' by running 'library(corporaexplorer)', then run 'run_corpus_explorer()'.",
      call. = FALSE
    )
  }

  if (class(corpus_object) != "corporaexplorerobject") {
    stop("'data' is not a corporaexplorerobject",
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

  shiny::shinyOptions("corporaexplorer_optional_info" = optional_info)
  shiny::shinyOptions("corporaexplorer_regex_engine" = regex_engine)
  shiny::shinyOptions("corporaexplorer_use_matrix" = use_matrix)
  shiny::shinyOptions("corporaexplorer_allow_unreasonable_patterns" = allow_unreasonable_patterns)
  shiny::shinyOptions("corporaexplorer_ui_options" = ui_options)
  shiny::shinyOptions("corporaexplorer_input_arguments" = search_input)


  data <- as.character(substitute(corpus_object))
  shiny::shinyOptions("corporaexplorer_data" = data)

  message(sprintf(
    "Exploring %s document%s",
    nrow(corpus_object$original_data$data_dok),
    if (nrow(corpus_object$original_data$data_dok) != 1) "s" else ""
  ))

  shiny::runApp(app, display.mode = "normal", ...)
}
