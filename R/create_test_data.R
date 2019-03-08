#' Create test_data
#'
#' @return A corpusexplorationobject used for testing
#' @keywords internal
create_test_data <- function() {
  dates <- as.Date(paste(2011:2020, 1:10, 21:30, sep = "-"))
  texts <- paste0(
    "This is a document about ",
    month.name[1:10],
    ". ",
    "This is not a document about ",
    rev(month.name[1:10]),
    "."
  )
  titles <- paste("Text", 1:10)
  test_df <-
    tibble::tibble(
      Date = dates,
      Text = texts,
      Title = titles
    )
  test_obj <- prepare_data(test_df)
  return(test_obj)
}
