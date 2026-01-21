#' Create a new 6 length colour vector from user input
#'
#' Comducting various checks and returning either new or
#'   standard colour vector
#'
#' @param input_colours Character. User input.
#' @param standard_colours Character. MAIN_COLOURS
#'
#' @return Character. New MAIN_COLOURS
create_colours_from_input <-
  function(input_colours, standard_colours) {
    if (!all(input_colours %in% standard_colours)) {
      return(standard_colours)
    }
    if (any(duplicated(input_colours))) {
      return(standard_colours)
    }
    return(c(
      input_colours,
      standard_colours[!standard_colours %in% input_colours]
    ))
  }
