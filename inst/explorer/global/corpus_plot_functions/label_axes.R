#' Labels for plot y axis.
#'
#' @param Df.
#'
#' @return List length 2: numeric vectors with breaks and labels, respectively,
label_y_axis <- function(test1) {
    test1$label_id <- seq_len(nrow(test1))

    ## For å automatisere label-årstall på y-aksen

    testus <- test1 %>%
        dplyr::group_by(Year_) %>%
        dplyr::slice(c(1, dplyr::n())) %>%
        dplyr::select(Year_, label_id) %>%
        dplyr::mutate(min_id = min(label_id),
               max_id = max(label_id)) %>%
        dplyr::slice(1) %>%
        dplyr::select(-label_id) %>%
        dplyr::ungroup()
    y_breaks <-
        (test1$y_max[testus$max_id] + test1$y_min[testus$min_id]) / 2
    y_labels <- testus$Year_

    y_text <- list(breaks = y_breaks, labels = y_labels)
    return(y_text)
}


#' Labels for plot x axis in calendar view.
#'
#' @param Df.
#'
#' @return Numeric vectors with breaks for x axis (months will be labels).
label_x_axis_365 <- function(test1) {
    x_breaks <- test1 %>%
        dplyr::group_by(Month) %>%
        dplyr::summarise(Midten = (min(x_min) + max(x_max)) / 2, .groups = "drop_last") %>%
        .$Midten
    return(x_breaks)
}
