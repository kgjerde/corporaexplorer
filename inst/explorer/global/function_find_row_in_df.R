#' Identify row in corpus df that corresponds to click in corpus map
#'
#' @param musepos List returned from shiny
#' @param plot_utforsk Plot info object
#'
#' @return Numeric. Row in data frame.
finn_min_rad <- function(musepos, plot_utforsk) {
  # Identifisere unik rad i data ut fra museposisjon
  min_rad <- plot_utforsk[
    musepos$x > plot_utforsk$xmin &
      musepos$x < plot_utforsk$xmax &
      musepos$y > plot_utforsk$ymin * -1 &
      # *-1 fordi reverse y-scale
      musepos$y < plot_utforsk$ymax * -1,
  ] # *-1 fordi reverse y-scale
  min_rad <- as.numeric(rownames(min_rad))
  return(min_rad)
}
