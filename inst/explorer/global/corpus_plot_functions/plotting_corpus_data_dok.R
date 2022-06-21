#' Main function for ggplot2 corpus map creation: document brick wall view
#'
#' @param test1 Data frame with columns XXXX
#' @param x_breaks
#' @param y_text
#' @param legend_df
#' @param linjer
#'
#' @return A ggplot2 plot object
plotting_corpus_data_dok <-
  function(test1,
           y_text,
           legend_df,
           linjer) {


a <- ggplot2::ggplot()

a <-
  a + ggplot2::scale_fill_identity(
    labels = legend_df$legend_label,
    #navn_vektor,
    breaks = legend_df$colour_code,
    #names(navn_vektor),
    guide = "legend",
    na.value = "white",
    drop=FALSE  # To include my dummy levels
  )

# Fill, one for each search_term (or for no search_term)

for (i in seq_len(linjer)) {
  a <-
    a + ggplot2::geom_rect(data = test1[test1$df == i,],
                  ggplot2::aes(
                    xmin = x_min,
                    xmax = x_max,
                    ymin = y_min,
                    ymax = y_max,
                    fill = Term_color
                  ))
}

if (ONLY_ONE_GROUP_IN_NON_DATE_BASED_CORPUS == TRUE) {
  y_text <- NULL
}

a <- a +
  #coord_fixed(ratio = 1/linjer, expand = FALSE) +
  ggplot2::scale_y_reverse(
    breaks = y_text$breaks,
    labels = y_text$labels,
    expand = c(0, 0)
  )

a <- a +
  ggplot2::scale_x_continuous(expand = c(0, 0)) +
  ggplot2::labs(x = NULL, y = NULL) +
  ggplot2::theme(axis.ticks.y = ggplot2::element_blank()) +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    panel.grid.major = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    axis.title.x = ggplot2::element_blank(),
    axis.text.x = ggplot2::element_blank(),
    axis.ticks.x = ggplot2::element_blank(),
    legend.position = "top",
    legend.title = ggplot2::element_blank(),
    axis.text = ggplot2::element_text(size=11,
                                      face = "bold")
  ) +
  ggplot2::guides(fill = ggplot2::guide_legend(ncol = NUMBER_OF_FACTORS, byrow = TRUE))

rect_tib_vertikal <- tibble::tibble(
  x = test1[test1$df == 1,]$x_min,
  xend = test1[test1$df == 1,]$x_max,
  y = test1[test1$df == 1,]$y_min,
  yend = test1[test1$df == 1,]$y_max + linjer - 1,
  # + 2 fordi tre rader i hver dokument FIX
  Year_ = test1$Year_[test1$df == 1],
)

rect_tib_vertikal$x_mid <- (rect_tib_vertikal$x + rect_tib_vertikal$xend) /
  2
rect_tib_vertikal$y_mid <- (rect_tib_vertikal$y + rect_tib_vertikal$yend) /
  2

# dividing_lines_btwn_groups ------------------------------

# Check if there are more than one group
if (length(unique(test1$Year_)) > 1) {

  # Find the y coordinate between the groups
  coordinates_for_dividing_lines_btwn_groups <-
    which(test1$Year_numeric != dplyr::lag(test1$Year_numeric))

  coordinates_for_dividing_lines_btwn_groups <-
    (test1$y_min[coordinates_for_dividing_lines_btwn_groups] +
       test1$y_max[coordinates_for_dividing_lines_btwn_groups - 1]) / 2

  # Make line(s) extend a bit to the right and left
  difference_min_max_x <- max(test1$x_max) - min(test1$x_min)

  a <-
    a + ggplot2::annotate(
      "segment",
      linetype = "solid",
      colour = "lightgray",
      size = 0.3 * linjer,
      x = min(test1$x_min) - (difference_min_max_x / 35),
      xend = max(test1$x_max) + (difference_min_max_x / 125),
      y = coordinates_for_dividing_lines_btwn_groups,
      yend = coordinates_for_dividing_lines_btwn_groups
    )
}


# Selve rutenettet
a <-
  a + ggplot2::geom_rect(
    data = rect_tib_vertikal,
    ggplot2::aes(
      xmin = x,
      ymin = y,
      xmax = xend,
      ymax = yend
    ),
    color = "black",
    fill = NA,
    size = 0.1
  )

return(a)
}
