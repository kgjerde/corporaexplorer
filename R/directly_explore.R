#' Directly explore data frame or character vector
#'
#' Function to directly explore data frame or character vector
#'   without first creating a corporaexplorerobject using
#'   \code{prepare_data()}, instead creating one on the fly as the app
#'   launches.
#'   Functionally equivalent to
#'   \code{run_corpus_explorer(prepare_data(dataset, use_matrix = FALSE))}.
#'   Interrupt R to stop the
#'   application (usually by pressing Ctrl+C or Esc).
#'
#' @param dataset Data frame or character vector as specified in \code{prepare_data()}
#' @param arguments_to_prepare_data List. Arguments to be passed to
#'   \code{prepare_data()} in order to overrule this function's
#'   default argument values.
#' @param arguments_to_run_corpus_explorer List. Arguments to be passed to
#'   \code{run_corpus_explorer()} in order to overrule this function's
#'   default argument values.
#'
#' @details By default, no document term matrix will be generated,
#'   meaning that the data will be prepared for exploration faster than
#'   by using the default settings in \code{prepare_data()},
#'   but also that searches in the app are likely to be slower.
#'
#' @return Launches a Shiny app.
#' @export
#'
#' @examples
#' if (interactive()) {
#'
#' directly_explore(rep(sample(LETTERS), 10))
#'
#' directly_explore(rep(sample(LETTERS), 10),
#'   arguments_to_run_corpus_explorer = list(search_input = list(search_terms = "Z"))
#' )
#'
#' }
directly_explore <- function(dataset,
         arguments_to_prepare_data = list(use_matrix = FALSE),
         arguments_to_run_corpus_explorer = list()) {
    # Step 1
    arguments_to_prepare_data <- c(list(dataset), arguments_to_prepare_data)
    corpus <- do.call(prepare_data, arguments_to_prepare_data)
    # Step 2
    arguments_to_run_corpus_explorer <- c(list(corpus), arguments_to_run_corpus_explorer)
    do.call(run_corpus_explorer, arguments_to_run_corpus_explorer)
}
