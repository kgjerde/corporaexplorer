#' Launching Shiny app for downloading documents from text collection
#'
#' Launch Shiny app for downloading documents from text collection.
#' Interrupt R to stop the application (usually by pressing Ctrl+C or Esc).
#'
#' @param data Either a \code{corpusexploration} object created by
#'   \code{\link[corpusexplorationr]{prepare_data}} or a data frame containing
#'   \code{Date} and \code{Text} columns.
#' @param ... Other arguments passed to \code{\link[shiny]{runApp}} in the Shiny
#'   package.
#' @export
#' @examples
#' # Constructing test data frame:
#' dates <- as.Date(paste(2011:2020, 1:10, 21:30, sep = "-"))
#' texts <- paste0("This is a document about ", month.name[1:10], ". ",
#'    "This is not a document about ", rev(month.name[1:10]), ".")
#' titles <- paste("Text", 1:10)
#' test_df <- data.frame(Date = dates, Text = texts, Title = titles)
#'
#' # Converting to corpusexploration object:
#' corpus <- prepare_data(test_df, corpus_name = "Test corpus")
#'
#' \dontrun{
#' # Running exploration app:
#' run_corpus_exploration(corpus)
#'
#' # Running download app:
#' run_download_tool(corpus)
#' # Or:
#' run_download_tool(test_df)
#' }
run_download_tool <- function(data, ...) {
  app <- system.file("download", "app.R", package = "corpusexplorationr")
  if (app == "") {
    stop("Could not find directory. Try re-installing `corpusexplorationr`.", call. = FALSE)
  }

  data <- as.character(substitute(data))
  shiny::shinyOptions("download_data" = data)

  shiny::runApp(app, display.mode = "normal", ...)
}
