#' Calculate size for corpus map plot
#'
#' @param df
#' @param max_width_for_row Must correspond with visualise_corpus()
#' @param x_factor
#' @param calendar_mode
#' @param number_of_search_terms
#' @param min_height
#'
#' @return Numeric
plot_size <-
    function(df,
             calendar_mode,
             max_width_for_row = MAX_WIDTH_FOR_ROW,
             x_factor = PLOT_SIZE_FACTOR,
             number_of_search_terms = 0,
             min_height = 100
             ) {
        if (calendar_mode == TRUE) {
            size <- plot_size_data_365(df, max_width_for_row, x_factor)
            if (number_of_search_terms > 1) {
                size <- size * (number_of_search_terms / 1.7)  # Divisor somewhat arbitrarily chosen through trying
            }
        } else if (calendar_mode == FALSE) {
            size <- plot_size_data_dok(df, max_width_for_row, x_factor)
            if (number_of_search_terms > 1) {
                if (DATE_BASED_CORPUS == FALSE) {
                    size <- size * (number_of_search_terms / 1.2)
                } else if (DATE_BASED_CORPUS == TRUE) {
                    size <- size * (number_of_search_terms / 1.5)
                    }  # Divisors somewhat arbitrarily chosen through trying
            }
        }
        if (size < min_height) {
            size <- min_height
        }
        return(ceiling(size))
    }

plot_size_data_365 <- function(df, max_width_for_row, x_factor) {
    years <- length(unique(df$Year))
    size <- years * 100
    return(size)
}

plot_size_data_dok <- function(df, max_width_for_row, x_factor) {
    size <- dplyr::group_by(df, Year) %>%
        dplyr::summarise(rader = ceiling(sum(Tile_length) / max_width_for_row), .groups = "drop_last") %>%
        dplyr::summarise(total = sum(rader), .groups = "drop_last") %>%
        unlist(use.names = FALSE)
    if (DATE_BASED_CORPUS == FALSE) {
        x_factor <- x_factor * 1
    }
    size <- size * x_factor
    # Because more groups = more vertical space use
    size <- size + (10 * length(unique(df$Year)))
    if (size > (30 * nrow(df))) {
        size <- 30 * nrow(df)
    }
    return(size)
}
