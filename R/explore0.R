#' Directly explore data frame or character vector
#'
#' \code{explore0()} is a convencience function to directly explore
#'   a data frame or character vector
#'   without first creating a corporaexplorerobject using
#'   \code{prepare_data()}, instead creating one on the fly as the app
#'   launches.
#'   Functionally equivalent to
#'   \code{explore(prepare_data(dataset, use_matrix = FALSE))}.
#'
#' @rdname explore
#' @order 3
#'
#' @param dataset Data frame or character vector as specified in \code{prepare_data()}
#' @param arguments_prepare_data List. Arguments to be passed to
#'   \code{prepare_data()} in order to override this function's
#'   default argument values.
#' @param arguments_explore List. Arguments to be passed to
#'   \code{explore()} in order to override this function's
#'   default argument values.
#'
#' @details For \code{explore0()}:
#'   by default, no document term matrix will be generated,
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
#' explore0(rep(sample(LETTERS), 10))
#'
#' explore0(rep(sample(LETTERS), 10),
#'   arguments_explore = list(search_input = list(search_terms = "Z"))
#' )
#'
#' }
explore0 <- function(dataset,
         arguments_prepare_data = list(use_matrix = FALSE),
         arguments_explore = list()) {
    message("Attempting to build corporaexplorerobject.")
    # Step 1
    arguments_prepare_data <- c(quote(dataset), arguments_prepare_data)
    corpus <- do.call(prepare_data, arguments_prepare_data)
    # Step 2
    arguments_explore <- c(quote(corpus), arguments_explore)
    do.call(explore, arguments_explore)
}
