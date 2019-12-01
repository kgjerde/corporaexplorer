#' Launch Shiny app for retrieval of documents from text collection
#'
#' Shiny app for simple retrieval/extraction of
#' documents from a "corporaexplorerobject" in a reading-friendly format.
#' Interrupt R to stop the application (usually by pressing Ctrl+C or Esc).
#'
#' @param corpus_object A \code{corporaexplorer} object created by
#'   \code{\link[corporaexplorer]{prepare_data}}.
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
#' test_df <- tibble::tibble(Date = dates, Text = texts, Title = titles)
#'
#' # Converting to corporaexplorer object:
#' corpus <- prepare_data(test_df, corpus_name = "Test corpus")
#' if(interactive()){
#' # Running exploration app:
#' explore(corpus)
#'
#' # Running app to extract documents:
#' run_document_extractor(corpus)
#' }
run_document_extractor <- function(corpus_object, max_html_docs = 400, ...) {
  app <- system.file("download", "app.R", package = "corporaexplorer")
  if (app == "") {
    stop("Could not find directory. Try re-installing `corporaexplorer`.", call. = FALSE)
  }

  if (class(corpus_object) != "corporaexplorerobject") {
    stop("'corpus_object' is not a corporaexplorerobject",
      call. = FALSE
    )
  }

  if ("package:corporaexplorer" %in% search() == FALSE) {
    stop(
      "Load 'corporaexplorer' by running 'library(corporaexplorer)', then run 'run_document_extractor()'.",
      call. = FALSE
    )
  }

  if (!is.numeric(max_html_docs)) {
    stop(sprintf("Invalid '%s' argument.", "max_html_docs"),
      call. = FALSE
    )
  }

  shiny::shinyOptions("corporaexplorer_download_data" = corpus_object)

  shiny::shinyOptions("corporaexplorer_download_max_html" = max_html_docs)

  shiny::shinyAppFile(app, options = list(display.mode = "normal", ...))
}
