#' Main function for ggplot2 corpus map creation: document brick wall view
#'
#' @param test1 Data frame with columns XXXX
#' @param x_breaks 
#' @param y_text 
#' @param til_legend 
#' @param linjer 
#'
#' @return A ggplot2 plot object
plotting_corpus_data_dok <-
  function(test1,
           y_text,
           til_legend,
           linjer) {



a <- ggplot2::ggplot()


farger <-
  c(rev(RColorBrewer::brewer.pal(9, name = "Reds")[2:9]), rev(RColorBrewer::brewer.pal(9, "Blues")[2:9]))



a <-
  a + ggplot2::scale_fill_identity(
    labels = til_legend$original,
    #navn_vektor,
    breaks = til_legend$fargekoder,
    #names(navn_vektor),
    guide = "legend",
    na.value = "white"
  )

a <-
  a + ggplot2::geom_rect(data = test1[test1$df == 1,],
                ggplot2::aes(
                  xmin = x_min,
                  xmax = x_max,
                  ymin = y_min,
                  ymax = y_max,
                  fill = Term_color
                ))#, fill = "red")

a <- a +
  #coord_fixed(ratio = 1/linjer, expand = FALSE) +
  ggplot2::scale_y_reverse(
    breaks = y_text$breaks,
    labels = y_text$labels,
    expand = c(0, 0)
  ) +
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
  ggplot2::guides(fill = ggplot2::guide_legend(ncol = 8, byrow = TRUE))

rect_tib_vertikal <- tibble::tibble(
  x = test1[test1$df == 1,]$x_min,
  xend = test1[test1$df == 1,]$x_max,
  y = test1[test1$df == 1,]$y_min,
  yend = test1[test1$df == 1,]$y_max + linjer - 1,
  # + 2 fordi tre rader i hver dokument FIX
  Year = test1$Year[test1$df == 1],
)

rect_tib_vertikal$x_mid = (rect_tib_vertikal$x + rect_tib_vertikal$xend) /
  2
rect_tib_vertikal$y_mid = (rect_tib_vertikal$y + rect_tib_vertikal$yend) /
  2


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


# dividing_lines_btwn_groups ------------------------------

coordinates_for_dividing_lines_btwn_groups <-
  which(!seq_len(max(test1$y_min)) %in% test1$y_min)

if (length(coordinates_for_dividing_lines_btwn_groups) > 0) {
  coordinates_for_dividing_lines_btwn_groups <-
    coordinates_for_dividing_lines_btwn_groups + 0.5

  difference_min_max_x <- max(test1$x_max) - min(test1$x_min)

  a <-
    a + ggplot2::annotate(
      "segment",
      linetype = "solid",
      colour = "lightgray",
      size = 0.3,
      x = min(test1$x_min) - (difference_min_max_x / 35),
      xend = max(test1$x_max) + (difference_min_max_x / 125),
      y = coordinates_for_dividing_lines_btwn_groups,
      yend = coordinates_for_dividing_lines_btwn_groups
    )
}
#####
# a <- a + ggplot2::scale_alpha_identity(na.value = test1$Odd)



if (linjer > 1) {
  #LINJE 2
  a <-
    a + ggplot2::geom_rect(data = test1[test1$df == 2,],
                  ggplot2::aes(
                    xmin = x_min,
                    xmax = x_max,
                    ymin = y_min,
                    ymax = y_max,
                    fill = Term_color
                  ))#, fill = "blue")#, color = "black", size = 0.1)
}

if (linjer > 2) {
  # LINJE 3
  a <-
    a + ggplot2::geom_rect(
      data = test1[test1$df == 3,],
      ggplot2::aes(
        xmin = x_min,
        xmax = x_max,
        ymin = y_min,
        ymax = y_max,
        alpha = Term_3
      ),
      fill = "green"
    )
}

if (linjer > 3) {
  # LINJE 4
  a <-
    a + ggplot2::geom_rect(
      data = test1[test1$df == 4,],
      ggplot2::aes(
        xmin = x_min,
        xmax = x_max,
        ymin = y_min,
        ymax = y_max,
        alpha = Term_4
      ),
      fill = "purple"
    )
}

if (linjer > 4) {
  # LINJE 5
  a <-
    a + ggplot2::geom_rect(
      data = test1[test1$df == 5,],
      ggplot2::aes(
        xmin = x_min,
        xmax = x_max,
        ymin = y_min,
        ymax = y_max,
        alpha = Term_5
      ),
      fill = "orange"
    )
}

if (linjer > 5) {
  # LINJE 6
  a <-
    a + ggplot2::geom_rect(
      data = test1[test1$df == 6,],
      ggplot2::aes(
        xmin = x_min,
        xmax = x_max,
        ymin = y_min,
        ymax = y_max,
        alpha = Term_5
      ),
      fill = "gray"
    )
}



return(a)
}
