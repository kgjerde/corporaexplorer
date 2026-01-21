# TODO: sørge for at avstanden mellom ruter ser lik ut på x- og y-akse.
#' Determine distance between days in single day view.
#'
#' @param test1 Df.
#' @param linjer Number of search term.
#' @param day_distance Between each document.
#'
#' @return Adjusted df.
create_distance_coordinates_day <- function(test1, linjer, day_distance) {
  ## AVSTAND MELLOM RUTER HORISONTALT
  day_distance <- 0.05

  test1 <- test1 %>%
    dplyr::group_by(rad) %>%
    dplyr::mutate(id_i_rad = dplyr::row_number(x_min) - 1) %>%
    dplyr::mutate(x_min = x_min + (day_distance * id_i_rad)) %>%
    dplyr::mutate(x_max = x_max + (day_distance * id_i_rad)) %>%
    dplyr::ungroup()

  ## AVSTAND MELLOM RUTER VERTIKALT
  row_distance <- 0.1 * linjer

  test1$group_row <- test1$rad - test1$df

  test1$y_min <-
    test1$y_min + (row_distance * test1$group_row)
  test1$y_max <-
    test1$y_max + (row_distance * test1$group_row)

  # Dette må til for ikke forskyvning og oppføkking ved > 1 søkeord. Men jeg forstår ikke helt.
  for (i in seq_len(max(test1$df))) {
    test1$y_min[test1$df == i] <- test1$y_min[test1$df == i] -
      (day_distance * (i - 1))
    test1$y_max[test1$df == i] <- test1$y_max[test1$df == i] -
      (day_distance * (i - 1))
  }
  #
  # ## AVSTAND MELLOM MÅNEDER
  # month_distance <- 1
  # test1$x_min <- test1$x_min + (month_distance * test1$Month -1)
  # test1$x_max <- test1$x_max + (month_distance * test1$Month -1)
  #
  # #AVSTAND MELLOM ÅR
  # year_distance<- 1.5
  # test1$y_min <- test1$y_min + (year_distance * test1$Year_ - min(test1$Year_))
  # test1$y_max <- test1$y_max + (year_distance * test1$Year_ - min(test1$Year_))

  return(test1)
}
