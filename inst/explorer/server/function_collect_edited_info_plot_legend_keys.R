#' Collect edited legend keys for corpus info plot
#'
#' @param terms Terms included in plot
#'
#' @return Character vector of terms in the UI input fields
collect_info_plot_legends <- function(terms) {
  new_terms <- character(0)

  for (i in seq_along(terms)) {
    new_terms[i] <- shiny::isolate(input[[paste0('info_legend_', i)]])
  }

  return(new_terms)
}
