#' Directly explore data frame or character vector
#'
#' Directly explore data frame or character vector
#'   without first creating a corporaexplorerobject using
#'   \code{prepare_data()}.
#'   Functionally equivalent to
#'   \code{run_corpus_explorer(prepare_data(dataset))}
#'
#' @param dataset Data frame or character vector as specified in \code{prepare_data()}
#' @param arguments_to_prepare_data List. Further arguments to be passed to
#'   \code{prepare_data()}
#' @param arguments_to_run_corpus_explorer List. Further arguments to be passed to
#'   \code{run_corpus_explorer()}
#'
#' @return Launches a Shiny app.
#' @export
#'
#' @examples
#' if (interactive()) {
#'
#' quickly_explore(rep(sample(LETTERS), 10))
#'
#' quickly_explore(rep(sample(LETTERS), 10),
#'   arguments_to_run_corpus_explorer = list(search_input = list(search_terms = "Z"))
#' )
#'
#' }
quickly_explore <- function(dataset,
         arguments_to_prepare_data = list(),
         arguments_to_run_corpus_explorer = list()) {
    # Step 1
    arguments_to_prepare_data <- c(list(dataset), arguments_to_prepare_data)
    corpus <- do.call(prepare_data, arguments_to_prepare_data)
    # Step 2
    arguments_to_run_corpus_explorer <- c(list(corpus), arguments_to_run_corpus_explorer)
    do.call(run_corpus_explorer, arguments_to_run_corpus_explorer)
}
