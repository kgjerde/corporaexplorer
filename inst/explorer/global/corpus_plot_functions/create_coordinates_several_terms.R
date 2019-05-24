#' Adjust coordinates when more than 1 search term
#'
#' @param test1 Data frame.
#' @param linjer Number of search terms. Arbitrary number allowed.
#'
#' @return Data frame with adjusted coordinates.
create_coordinates_several_search_terms <- function(test1, linjer) {
  # Klargjør for flere søke-ord
  test1 <- test1[rep(seq_len(nrow(test1)), each = linjer), ]
  test1$df <- rep(1:linjer, nrow(test1) / linjer)
  test1 <- dplyr::arrange(test1, y_min, df)

  test1 <- test1 %>%
    dplyr::mutate_at(dplyr::vars(dplyr::starts_with("Term_")), as.character)

  test1$Term <- NA

  for (i in seq_len(linjer)) {
    test1$Term[test1$df == i] <- test1[[sprintf("Term_%s", i)]][test1$df == i]
  }

  # Definerer hvilken rad som skal på hvilken rad i charten. Forstår ikke helt
  test1$rad <- NA
  test1$rad[test1$x_min == 0] <-
    seq(1, by = 1, length.out = length(test1$x_min[test1$x_min == 0]))
  test1$rad <- zoo::na.locf(test1$rad)

  ### Assigner y-verdier basert på at jeg allerede vet hvilken rad de skal ha
  test1$y_min <- test1$rad - 1
  test1$y_max <- test1$rad

  return(test1)
}
