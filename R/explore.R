#' Explore
#'
#' Convenience function. Calls \code{run_corpus_explorer()} if \code{x} is a "corporaexplorerobject",
#'   otherwise it calls \code{directly_explore()}.
#'   Interrupt R to stop the
#'   application (usually by pressing Ctrl+C or Esc).
#'
#' @param x corporaexplorerobject, data.frame or character vector as specified in
#'   \code{run_corpus_explorer()} and \code{directly_explore()}.
#' @param ... Further arguments to be passed to
#'   \code{run_corpus_explorer()} or \code{directly_explore()}
#'
#' @return Launch Shiny app
#' @keywords internal
#'
explore <- function(x, ...) {
    if ("corporaexplorerobject" %in% class(x)) {
        run_corpus_explorer(x, ...)
    } else {
        message("Attempting to build corporaexplorerobject.")
        directly_explore(x, ...)
    }
}

