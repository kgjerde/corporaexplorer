#' Creating coordinates for corpus plot in calendar view
#'
#' @param df Data frame including factors for each document according to
#'   search term count (from create_factors_for_labelling ()).
#'
#' @return Full data_365 df with additional columns determining plot coordinates
#'   for each day.
create_coordinates_1_data_365 <- function(df) {
  # Fordi rutene er størrelse 1
  x_max <- cumsum(df$Tile_length)
  x_min <- x_max - 1
  # (Foreløpig er dette bare til én lang rad - se group_by nedenfor)

  y_min <- rep(NA, nrow(df))

  # Markerer uke(=rad)-skifte
  skifte_weekday <-
    which(df$Weekday_n != dplyr::lead(df$Weekday_n))
  y_min[skifte_weekday] <- seq_along(skifte_weekday)

  # Fyller inn slik at alle dokumenter får sin y_min(=rad) på plass
  y_min <- replace_NAs_with_next_or_previous_non_NA(
    y_min,
    direction = "next",
    remove_na = FALSE
  )

  # Fordi plott er "opp-ned" og rute-størrelse er 1
  y_max <- y_min
  y_min <- y_max - 1

  # Kobler på df-tibble
  df$x_max <- x_max
  df$x_min <- x_min

  df$y_min <- y_min
  df$y_max <- y_max

  ## DATAFRAME FOR GGPLOT
  test1 <- df %>%
    # Fordi x skal begynne på nytt hver rad:
    dplyr::group_by(y_max) %>%
    dplyr::mutate(
      x_min2 = x_min - min(x_min),
      x_max2 = x_max - min(x_min)
    ) %>%
    dplyr::ungroup()

  test1 <- dplyr::select(test1, -x_min, -x_max, Day_without_docs) %>%
    dplyr::rename(x_min = x_min2, x_max = x_max2)
  return(test1)
}
