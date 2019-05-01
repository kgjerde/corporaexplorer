#' Main function for ggplot2 corpus map creation: calendar view
#'
#' @param test1 Data frame with columns XXXX
#' @param x_breaks 
#' @param y_text 
#' @param til_legend 
#' @param linjer 
#'
#' @return A ggplot2 plot object
plotting_corpus_data_365 <- function(test1, x_breaks, y_text, til_legend, linjer) {
    a <- ggplot2::ggplot()
    
    a <- a +
        ggplot2::scale_y_reverse(
            breaks = y_text$breaks,
            labels = y_text$labels,
            expand = c(0.0, 0.0)
        ) +
        ggplot2::scale_x_continuous(
            breaks = x_breaks,
            labels = month.abb[sort(unique(lubridate::month(test1$Date)))],
            position = "top",
            expand = c(0.0, 0.0)
        ) +
        ggplot2::labs(x = NULL, y = NULL) +
        ggplot2::theme(axis.ticks.y = ggplot2::element_blank()) +
        ggplot2::theme_minimal() +
        ggplot2::theme(
            panel.grid.major = ggplot2::element_blank(),
            panel.grid.minor = ggplot2::element_blank(),
            legend.position = "top",
            legend.title = ggplot2::element_blank(),
            axis.text = ggplot2::element_text(size=10)
        ) +
        ggplot2::guides(fill = ggplot2::guide_legend(ncol = 8, byrow = TRUE))
    
    rect_tib_vertikal <- tibble::tibble(
        x = test1[test1$df == 1,]$x_min,
        xend = test1[test1$df == 1,]$x_max,
        y = test1[test1$df == 1,]$y_min,
        yend = test1[test1$df == 1,]$y_max + linjer - 1,
        Year = test1$Year[test1$df == 1],
        Month = test1$Month[test1$df == 1]
    )
    
    rect_tib_vertikal$x_mid = (rect_tib_vertikal$x + rect_tib_vertikal$xend) /
        2
    rect_tib_vertikal$y_mid = (rect_tib_vertikal$y + rect_tib_vertikal$yend) /
        2

    rect_tib_vertikal$Day_without_docs <- test1$Day_without_docs[test1$df == 1]

    a <-
        a + ggplot2::scale_fill_identity(
            labels = til_legend$original,
            #navn_vektor,
            breaks = til_legend$fargekoder,
            #names(navn_vektor),
            guide = "legend",
            na.value = "white"
        )
    # }
    
    # Dette er fyll basert på søk
    a <-
        a + ggplot2::geom_rect(data = test1[test1$df == 1,],
                      ggplot2::aes(
                          xmin = x_min,
                          xmax = x_max,
                          ymin = y_min,
                          ymax = y_max,
                          fill = Term_color
                      ))
    
    
    #    Dette er selve rutenettet
    a <- a + ggplot2::geom_rect(
        data = rect_tib_vertikal
        ,
        ggplot2::aes(
            xmin = x,
            ymin = y,
            xmax = xend,
            ymax = yend
        ),
        fill = NA,
        color = "black",
        size = 0.15
    )# +
    #  ggplot2::theme(legend.position = "none")
    
    # # Og her er for å indikere dager uten dokumenter:
    a <-
        a + ggplot2::geom_rect(
            data = rect_tib_vertikal[rect_tib_vertikal$Day_without_docs == TRUE,],
            ggplot2::aes(
                xmin = x,
                ymin = y,
                xmax = xend,
                ymax = yend
            ),
            fill = "white",
            colour = "white",
            size = 0.2,
            na.rm = TRUE
        )
    
    # Og her skjuler vi ikke-eksisterende dager og dager utenfor datasettet
    a <-
        a + ggplot2::geom_rect(
            data = test1[test1$Invisible_fake_date == TRUE,],
            ggplot2::aes(
                xmin = x_min,
                xmax = x_max,
                ymin = y_min,
                ymax = y_max
            ),
            fill = "white",
            size = 1,
            colour = "white"
        )
    
    a <- a + ggplot2::scale_alpha_identity()
    
    
    
    
    
    if (linjer > 1) {
        #LINJE 2
        a <-
            a + ggplot2::geom_rect(
                data = test1[test1$df == 2,],
                ggplot2::aes(
                    xmin = x_min,
                    xmax = x_max,
                    ymin = y_min,
                    ymax = y_max,
                    fill = Term_color
                )
            )

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
                    fill = Term_color
                )
            )
        #alpha = Term_3), fill = "green")
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
