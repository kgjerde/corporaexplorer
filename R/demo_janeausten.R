#' Demo app: Jane Austen's novels
#' @name demo_jane_austen
NULL

#' Demo app: Jane Austen's novels
#'
#' \code{run_janeausten_app()} is a convenience function to directly
#'   run the demo app without first creating
#'   a corporaexplorerobject.
#'   Equals \code{explore(create_janeausten_app())}.
#'   Interrupt R to stop the
#'   application (usually by pressing Ctrl+C or Esc).
#'
#' @param ... Arguments passed to \code{explore()}
#' @details The demo app's data are Jane Austen's six novels, retrieved
#'   through the "janeaustenr" package
#'   (\url{https://github.com/juliasilge/janeaustenr}) --
#'   which must be installed for these functions to work --
#'   and converted to a corporaexplorerobject as shown at
#'   \url{https://kgjerde.github.io/corporaexplorer/articles/jane_austen.html}.
#' @rdname demo_jane_austen
#' @return \code{run_janeausten_app()} launches a Shiny app. \code{create_janeausten_app()} returns
#'   a corporaexplorerobject.
#' @export
#' @examples
#' ## Create corporaexplorerobject for demo app:
#' jane_austen <- create_janeausten_app()
#'
#' if(interactive()){
#'
#' ## Run the corporaexplorerobject:
#' explore(jane_austen)
#'
#' ## Or create and run the demo app in one step:
#'
#' run_janeausten_app()
#'
#' }
run_janeausten_app <- function(...) {

    user_options <- list(...)

    search_options_ <- user_options$search_options
    plot_options_ <- user_options$plot_options
    search_input_ <- user_options$search_input
    ui_options_ <- user_options$ui_options

    if (is.null(plot_options_$plot_size_factor)) {
        plot_options_$plot_size_factor <- 1.3
    }

    jane_austen <- create_janeausten_app()
    explore(jane_austen,
                        search_options = search_options_,
                        plot_options = plot_options_,
                        search_input = search_input_,
                        ui_options = ui_options_)
}

#' Create demo app
#'
#' @export
#' @rdname demo_jane_austen
create_janeausten_app <- function() {

  if (!requireNamespace("janeaustenr", quietly = TRUE)) {
    stop('The demo app uses data from the "janeaustenr" package. Please install it by running: install.packages("janeaustenr")',
      call. = FALSE)
  }

    books <- janeaustenr::austen_books()
    # Regular expression to identify where new chapters begin
    chapter_regex <- "((Chapter|CHAPTER|VOLUME) (\\d+|[IXVL])+)"
    # Pre-processing
    books <- books %>%
        dplyr::group_by(book) %>%
        # Each book into one long string:
        dplyr::summarise(Text = paste(text, collapse = " ")) %>%
        # Insert placeholder at beginning of each chapter
        dplyr::mutate(Text = stringr::str_replace_all(Text, chapter_regex, "NEW_CHAPTER\\1")) %>%
        # Replace double space with two newlines (to restore structure of the text):
        dplyr::mutate(Text = stringr::str_replace_all(Text, "  ", "\n\n")) %>%
        # Split each book into a character vector (one element is one chapter):
        dplyr::mutate(Text = stringi::stri_split_regex(Text, "NEW_CHAPTER")) %>%
        # Remove first element (book title), so the books start with Chapter 1
        dplyr::mutate(Text = lapply(Text, function(x)
            x[-1]))
    # The result is a data frame with one row for each book.
    # The "Text" column is a list of character vectors
    # The "book" column is the name of the book
    # From one row per book to one row per chapter
    books <- tidyr::unnest(books, Text)
    # As this is a corpus which is not organised by date,
    # we set `date_based_corpus` to `FALSE`.
    # Because we want to organise our exploration around Jane Austen's books,
    # we pass `"book"` to the `grouping_variable` argument.
    jane_austen <- corporaexplorer::prepare_data(
        dataset = books,
        date_based_corpus = FALSE,
        grouping_variable = "book"
    )
}
