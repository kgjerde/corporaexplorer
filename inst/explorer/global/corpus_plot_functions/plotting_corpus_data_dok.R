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
    legend.title = ggplot2::element_blank()
  ) +
  ggplot2::guides(fill = ggplot2::guide_legend(ncol = 8, byrow = TRUE))

rect_tib_vertikal <- tibble::tibble(
  x = test1[test1$df == 1,]$x_min,
  xend = test1[test1$df == 1,]$x_max,
  y = test1[test1$df == 1,]$y_min,
  yend = test1[test1$df == 1,]$y_max + linjer - 1,
  # + 2 fordi tre rader i hver dokument FIX
  Year = test1$Year[test1$df == 1],
  Month = test1$Month[test1$df == 1]
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



##### SKILLELINJER MELLOM ÅR

  year_divide <- rect_tib_vertikal %>%
    dplyr::group_by(Year) %>%
    dplyr::arrange(yend) %>%
    dplyr::slice(1)


x_ <- integer()
xend_ <- integer()
y_ <- integer()
yend_ <- integer()
x_2 <- integer()
xend_2 <- integer()
y_2 <- integer()
yend_2 <- integer()
Year_ <- integer()
Month_ <- integer()
for (i in seq_len(nrow(year_divide))) {
  x_[i]       <- 0
  xend_[i]    <- year_divide$x[i]
  y_[i]       <- year_divide$yend[i]
  yend_[i]    <- year_divide$yend[i]
  x_2[i]      <- year_divide$x[i]
  xend_2[i]   <-
    max(test1$x_max[test1$y_max == year_divide$yend[i]])
  y_2[i]      <- year_divide$y[i]
  yend_2[i]   <- year_divide$y[i]
  Year_[i]     <- year_divide$Year[i]
  Month_[i]    <- year_divide$Month[i]
}

year_divide <-
  tibble::tibble(
    x = c(x_, x_2),
    xend =  c(xend_, xend_2),
    y = c(y_, y_2),
    yend = c(yend_, yend_2),
    Year = c(Year_, Year_),
    Month = c(Month_, Month_)
  )

# oskar <<- year_divide


a <-
  a + ggplot2::annotate(
    "segment",
    x = year_divide$x,
    xend = year_divide$xend,
    y = year_divide$y,
    yend = year_divide$yend
  )

#### SISTE VERTIKALE SKILLELINJER ####

  unike_aar <- unique(year_divide$Year)
  
  x <- integer()
  y <- integer()
  yend <- integer()
  
  for (i in seq_along(unike_aar)) {
    if (max(year_divide$yend[year_divide$Year == unike_aar[i]]) != min(year_divide$yend[year_divide$Year == unike_aar[i]])) {
      x[i] <-     max(year_divide$x[year_divide$Year == unike_aar[i]])
      y[i] <-
        min(year_divide$y[year_divide$Year == unike_aar[i]])
      yend[i] <-
        max(year_divide$yend[year_divide$Year == unike_aar[i]])
    }
  }


oppoverpiler <- tibble::tibble(x, y, yend)



a <-
  a + ggplot2::annotate(
    "segment",
    x = oppoverpiler$x,
    xend = oppoverpiler$x,
    y = oppoverpiler$y,
    yend = oppoverpiler$yend
  )

#####

a <- a + ggplot2::scale_alpha_identity(na.value = test1$Odd)



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
