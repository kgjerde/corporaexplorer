#' Launching Shiny app for exploration of text collection
#'
#' Launch Shiny app for exploration of text collection. Interrupt R to stop the
#' application (usually by pressing Ctrl+C or Esc).
#'
#' @param corpus_object A corpusexploration object created by
#'   \code{\link[corpusexplorationr]{prepare_data}}.
#' @param optional_info YEE
#' @param regex_engine YEE
#' @param use_matrix If the corpusexplorationobject contains a document term
#'   matrix, should it be used?
#' @param ... Other arguments passed to \code{\link[shiny]{runApp}} in the Shiny
#'   package.
#' @export
#' @rawNamespace import(data.table, except = ":=")
#' @import rlang
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
run_corpus_explorer <- function(corpus_object,
                                optional_info = FALSE,
                                regex_engine = c("default",
                                                 "stringr",
                                                 "re2r"),
                                use_matrix = TRUE,
                                ...) {
  app <- system.file("explorer", "app.R", package = "corpusexplorationr")
  if (app == "") {
    stop("Could not find directory. Try re-installing `corpusexplorationr`.",
         call. = FALSE)
  }

  if (class(corpus_object) != "corpusexplorationobject") {
    stop("'data' is not a corpusexplorationobject",
         call. = FALSE)
  }


  if (!is.logical(optional_info)) {
    stop(sprintf("Invalid '%s' argument.", "optional_info"),
         call. = FALSE)
  }

  if (identical(regex_engine, c("default",
                            "stringr",
                            "re2r"))) {
    regex_engine <- "default"
  }

  if (!(regex_engine %in% c("default",
                            "stringr",
                            "re2r"))) {
    stop(sprintf("Invalid '%s' argument.", "regex_engine"),
         call. = FALSE)
  }

  shiny::shinyOptions("corpusexplorationr_optional_info" = optional_info)
  shiny::shinyOptions("corpusexplorationr_regex_engine" = regex_engine)
  shiny::shinyOptions("corpusexplorationr_use_matrix" = use_matrix)

  data <- as.character(substitute(corpus_object))
  shiny::shinyOptions("corpusexplorationr_data" = data)

  message(sprintf("Exploring %s document%s",
                  nrow(corpus_object$original_data$data_dok),
                  if (nrow(corpus_object$original_data$data_dok) != 1) "s" else ""))

  shiny::runApp(app, display.mode = "normal", ...)
}
