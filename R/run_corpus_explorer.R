#' Launch Shiny app for exploration of text collection
#'
#' Launch Shiny app for exploration of text collection. Interrupt R to stop the
#' application (usually by pressing Ctrl+C or Esc).
#'
#' @param corpus_object A corporaexplorerobject created by
#'   \code{\link[corporaexplorer]{prepare_data}}.
#' @param search_options List. Specify how search operations in the app are
#'   carried out. Available options:
#' \itemize{
#'     \item \code{use_matrix} Logical. If the corporaexplorerobject contains a document
#'     term matrix, should it be used for searches? (See
#'     \code{\link[corporaexplorer]{prepare_data}}.) Defaults to \code{TRUE}.
#'     \item \code{regex_engine} Character. Specify regular expression engine to be used
#'     (defaults to \code{"default"}). Available options:
#'     \itemize{
#'         \item "default": use the \code{re2r} package
#'         (\url{https://github.com/qinwf/re2r}) for simple searches and the
#'         \code{stringr} package (\url{https://github.com/tidyverse/stringr} for
#'         complex regexes (i.e. when special regex characters are used).
#'         \item "stringr": use \code{stringr} for all searches.
#'         \item "re2r": use \code{re2r} for all searches.
#'     }
#'     \item \code{optional_info} Logical. If \code{TRUE}, information about search method
#'     (regex engine and whether the search was conducted in the document term
#'     matrix or in the full text documents).
#'     \item \code{allow_unreasonable_patterns} Logical. If \code{FALSE}, the default, the app will
#'     not allow patterns that will result in an enormous amount of hits or will
#'     lead to a very slow search. (Examples of such patterns will include
#'     '\code{.}' and '\code{\\b}'.)
#' }
#' @param ui_options List. Specify custom app settings (see example below).
#'   Currently available:
#' \itemize{
#'     \item \code{font_size}. Character string specifying font size in
#'     document view,
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
#' @param plot_options List. Specify custom plot settings (see example below).
#'   Currently available:
#' \itemize{
#'     \item \code{max_docs_in_wall_view}. Integer specifying the maximum number
#'      of documents to be rendered in the 'document wall' view.
#'      Default value is 12000.
#'     \item \code{plot_size_factor}. Numeric. Tweaks the corpus map plot's
#'      height. Value > 1 increases height, value < 1 decreases height.
#'      Ignored if value <= 0.
#'     \item \code{documents_per_row_factor}. Numeric. Tweaks the number of
#'      documents included in each row in 'document wall' view. Value > 1
#'       increases number of documents, value < 1 decreases number of
#'       documents. Ignored if value <= 0.
#'     \item \code{document_tiles}. Integer specifying the number of tiles
#'       used in the tile chart representing occurences of terms in document.
#'       Ignored if value < 1 or if value > 50.
#'     \item \code{colours}. Character vector of length 1 to 6. Specify the
#'      order of the colours used to represent search (and highlight) terms
#'      in plots and documents. The default order and available colours are
#'      defined by the character vector
#'      \code{c("red", "blue", "green", "purple", "orange", "gray")}.
#'      Passing e.g. \code{plot_options = list(colours = c("gray", "green"))}
#'      will change that order to
#'      \code{c("gray", "green", "red", "blue", "purple", "orange")}.
#'      Arguments with duplicated colours or with colours not present in the
#'      default character vector will be ignored.
#'      }
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
#'
#' # Running exploration app:
#' run_corpus_explorer(corpus)
#' run_corpus_explorer(corpus,
#'                     search_options = list(optional_info = TRUE),
#'                     ui_options = list(font_size = "10px"),
#'                     search_input = list(search_terms = c("Tottenham", "Spurs")),
#'                     plot_options = list(MAX_DOCS_IN_WALL_VIEW = 12001,
#'                                         colours = c("gray", "green")))
#'
#' # Running app to extract documents:
#' run_document_extractor(corpus)
#' }
run_corpus_explorer <- function(corpus_object,
                                search_options = list(),
                                ui_options = list(),
                                search_input = list(),
                                plot_options = list(),
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

  if ("corporaexplorerobject" %in% class(corpus_object) == FALSE) {
    stop("'data' is not a corporaexplorerobject",
      call. = FALSE
    )
  }


# Deprecated arguments ----------------------------------------------------

  if (!is.null(ui_options$MAX_DOCS_IN_WALL_VIEW)) {
    warning("The `MAX_DOCS_IN_WALL_VIEW` option is now part of the `plot_options` argument, but with lower case. E.g. `plot_options = list(max_docs_in_wall_view = 15000)`. This warning message will be removed in future releases.",
      call. = FALSE,
      immediate. = TRUE
    )
  }

  deprecated_arguments <- c("use_matrix",
                            "regex_engine",
                            "optional_info",
                            "allow_unreasonable_patterns")

  for (name in deprecated_arguments) {
    if (name %in% names(list(...))) {
      warning(
        sprintf(
          "Argument `%s` is deprecated. Use argument `search_options` instead.",
          name
        ),
        call. = FALSE,
        immediate. = TRUE
      )
    }
  }


# Pass data ---------------------------------------------------------------

  shiny::shinyOptions("corporaexplorer_search_options" = search_options)
  shiny::shinyOptions("corporaexplorer_ui_options" = ui_options)
  shiny::shinyOptions("corporaexplorer_input_arguments" = search_input)
  shiny::shinyOptions("corporaexplorer_plot_options" = plot_options)

  shiny::shinyOptions("corporaexplorer_data" = corpus_object)

  message(sprintf(
    "Exploring %s document%s",
    nrow(corpus_object$original_data$data_dok),
    if (nrow(corpus_object$original_data$data_dok) != 1) "s" else ""
  ))

  shiny::shinyAppFile(app, options = list(display.mode = "normal", ...))
}
