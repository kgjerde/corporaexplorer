#' Creating coordinates for corpus plot in calendar view
#'
#' @param .data Data frame including factors for each document according to
#'   search term count (from create_factors_for_labelling ()).
#'
#' @return Full data_365 df with additional columns determining plot coordinates
#'   for each day.
create_coordinates_1_data_365 <- function(.data) {
    # Fordi rutene er størrelse 1
    x_max <- cumsum(.data$wc)
    x_min <- x_max - 1
    # (Foreløpig er dette bare til én lang rad - se group_by nedenfor)
    
    y_min <- rep(NA, nrow(.data))
    
    # Markerer uke(=rad)-skifte
    skifte_weekday <-
        which(.data$Weekday_n != dplyr::lead(.data$Weekday_n))
    y_min[skifte_weekday] <- seq_along(skifte_weekday)
    
    # Fyller inn slik at alle dokumenter får sin y_min(=rad) på plass
    y_min <- zoo::na.locf(y_min, fromLast = TRUE)
    
    # y_min-vektor blir like lang som nrow(.data)
    y_min <-
        c(y_min, rep(max(y_min) + 1, nrow(.data) - length(y_min)))
    
    # Fordi plott er "opp-ned" og rute-størrelse er 1
    y_max <- y_min
    y_min <- y_max - 1
    
    # Kobler på .data-tibble
    .data$x_max <- x_max
    .data$x_min <- x_min
    
    .data$y_min <- y_min
    .data$y_max <- y_max
    
    
    ## DATAFRAME FOR GGPLOT
    test1 <- .data %>%
        # Fordi x skal begynne på nytt hver rad:
        dplyr::group_by(y_max) %>%
        dplyr::mutate(x_min2 = x_min - min(x_min),
               x_max2 = x_max - min(x_min)) %>%
        dplyr::ungroup()
    
    test1 <- dplyr::select(test1,-x_min,-x_max, empty) %>%
        dplyr::rename(x_min = x_min2,
               x_max = x_max2)
return(test1)
    }
