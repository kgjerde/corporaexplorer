#' Launching Shiny app for downloading documents from text collection
#'
#' Launch Shiny app for downloading documents from text collection.
#' Interrupt R to stop the application (usually by pressing Ctrl+C or Esc).
#'
#' @param corpus_object A \code{corpusexploration} object created by
#'   \code{\link[corpusexplorationr]{prepare_data}}.
#' @param max_html_docs The maximum number of documents allowed in one HTML report.
#' @param ... Other arguments passed to \code{\link[shiny]{runApp}} in the Shiny
#'   package.
#' @export
#' @examples
#' # Constructing test data frame:
#' dates <- as.Date(paste(2011:2020, 1:10, 21:30, sep = "-"))
#' texts <- paste0(
#'   "This is a document about ", month.name[1:10], ". ",
#'   "This is not a document about ", rev(month.name[1:10]), "."
#' )
#' titles <- paste("Text", 1:10)
#' test_df <- data.frame(Date = dates, Text = texts, Title = titles)
#' 
#' # Converting to corpusexploration object:
#' corpus <- prepare_data(test_df, corpus_name = "Test corpus")
#' \dontrun{
#' # Running exploration app:
#' run_corpus_exploration(corpus)
#' 
#' # Running app to extract documents:
#' run_document_extractor(corpus)
#' # Or:
#' run_document_extractor(test_df)
#' }
run_document_extractor <- function(corpus_object, max_html_docs = 400, ...) {
  app <- system.file("download", "app.R", package = "corpusexplorationr")
  if (app == "") {
    stop("Could not find directory. Try re-installing `corpusexplorationr`.", call. = FALSE)
  }

  if (class(corpus_object) != "corpusexplorationobject") {
    stop("'corpus_object' is not a corpusexplorationobject",
      call. = FALSE
    )
  }

  if ("package:corpusexplorationr" %in% search() == FALSE) {
    stop(
      "Load 'corpusexplorationr' by running 'library(corpusexplorationr)', then run 'run_document_extractor()'.",
      call. = FALSE
    )
  }

  if (!is.numeric(max_html_docs)) {
    stop(sprintf("Invalid '%s' argument.", "max_html_docs"),
      call. = FALSE
    )
  }

  corpus_object <- as.character(substitute(corpus_object))
  shiny::shinyOptions("corpusexplorationr_download_data" = corpus_object)

  shiny::shinyOptions("corpusexplorationr_download_max_html" = max_html_docs)

  shiny::runApp(app, display.mode = "normal", ...)
}
