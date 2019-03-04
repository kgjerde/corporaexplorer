#' Main function for ggplot2 corpus map creation: 'a day in the corpus' view
#'
#' @param test1 Data frame with columns XXXX
#' @param x_breaks 
#' @param y_text 
#' @param til_legend 
#' @param linjer 
#'
#' @return A ggplot2 plot object
plotting_corpus_day <-
  function(test1,
           linjer) {   
 a <- ggplot2::ggplot()

    a <- a + ggplot2::geom_rect(data = test1[test1$df == 1, ], ggplot2::aes(xmin = x_min, xmax = x_max, ymin = y_min, ymax = y_max,
                      fill = Term_color))
    
    a <- a + 
        #ggplot2::coord_fixed(ratio = 1/linjer, expand = FALSE) +
        ggplot2::scale_y_reverse(expand = c(0,0)) +  # (breaks = y_text$breaks, labels = y_text$labels,
        ggplot2::scale_x_continuous(
            # breaks = 1,
            labels = NULL,#paste(data_day$Date[1]),
            # position = "top",
            expand = c(0,0)) +
        ggplot2::labs(x = NULL, y = NULL) +
        ggplot2::theme(axis.ticks.y=ggplot2::element_blank()) +
        ggplot2::theme_minimal() +
        ggplot2::theme(panel.grid.major = ggplot2::element_blank(),
              panel.grid.minor = ggplot2::element_blank(),
              axis.text.x = ggplot2::element_text(size = 12),
              axis.text.y=ggplot2::element_blank(),
              axis.ticks.x=ggplot2::element_blank(),
              legend.position="top", legend.title=ggplot2::element_blank())
    
    rect_tib_vertikal <- tibble::tibble(x = test1[test1$df == 1, ]$x_min,
                               xend = test1[test1$df == 1, ]$x_max,
                               y = test1[test1$df == 1, ]$y_min,
                               yend = test1[test1$df == 1, ]$y_max + linjer - 1,  # + 2 fordi tre rader i hver dokument FIX
                               Year = test1$Year[test1$df == 1],
                               Month = test1$Month[test1$df == 1])
    
    rect_tib_vertikal$x_mid = (rect_tib_vertikal$x + rect_tib_vertikal$xend)/2
    rect_tib_vertikal$y_mid = (rect_tib_vertikal$y + rect_tib_vertikal$yend)/2
    
    a <- a + ggplot2::geom_rect(data = rect_tib_vertikal, ggplot2::aes(xmin = x, ymin = y, xmax = xend, ymax = yend),
                       color = "black",
                        fill = NA, size = 0.1,
                       show.legend = FALSE)
    
  a <-
  a + ggplot2::scale_fill_identity(
    na.value = "white"
  )

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
  
a <- a + ggplot2::geom_text(data = rect_tib_vertikal, ggplot2::aes(x= x_mid, y = y_mid, label = seq_along(test1$df[test1$df == 1])), size = 4)#, alpha = 0.6)

       
    return(a)
        }
