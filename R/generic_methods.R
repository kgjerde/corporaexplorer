#' Print corporaexplorerobject
#'
#' @param x A corporaexplorerobject
#'
#' @return Console-friendly output
#' @keywords internal
#' @export
print.corporaexplorerobject <- function(x, ...) {
  cat("corporaexplorerobject\n")
  if (!is.null(x$corpus_name)) {
    cat("Corpus name:", x$corpus_name, "\n")
  }

  cat(
    "Created with corporaexplorer version",
    as.character(x[["version"]]),
    "\n"
  )

  cat("Documents:", nrow(x$original_data$data_dok), "\n")

  if (identical(x[["original_matrix"]][["data_dok"]], FALSE) == FALSE) {
    cat(
      "Contains matrix with",
      length(x[["ordvektorer"]][["data_dok"]]),
      "unique tokens\n"
    )
  }

  if (isTRUE(x$date_based_corpus)) {
    cat(
      "Date based corpus:",
      as.character(x[["original_data"]][["data_dok"]][["Date"]][1]),
      "to",
      as.character(x[["original_data"]][["data_dok"]][["Date"]][nrow(x[["original_data"]][["data_dok"]])]),
      "\n"
    )
  }
}
