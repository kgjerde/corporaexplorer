#' @title Deprecated: run_corpus_explorer()
#'
#' @description Deprecated. Use \code{explore()} instead.
#'
#' @name run_corpus_explorer-deprecated
#' @seealso \code{\link{corporaexplorer-deprecated}}
#' @keywords internal
NULL

#' @rdname corporaexplorer-deprecated
#'
#' @param ... For \code{run_corpus_explorer},
#'   arguments passed to \code{explore()}
#'
#' @section \code{run_corpus_explorer}:
#' For \code{run_corpus_explorer}, use \code{\link{explore}}.
#'
#' @export
run_corpus_explorer <- function(...) {
  .Deprecated("explore")

  explore(...)
}
