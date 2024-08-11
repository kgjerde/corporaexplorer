#' Determine distance between days in calendar view plot.
#'
#' @param test1 Df.
#' @param linjer Number of search term.
#' @param row_distance Vertical distance between each document when
#'   more than one search terms
#' @param year_distance Vertical distance between each year/group
#'
#' @return Adjusted df.
create_distance_coordinates_dok <- function(test1,
                                        linjer,
                                        row_distance = 0.15,
                                        horizontal_distance = 0.3,
                                        year_distance = 1
                                        ){
    # IF SEVERAL SEARCH TERMS

    if (linjer > 1) {
        # DISTANCE BETWEEN DOCS VERTICALLY
        # Making sure that all tiles "belonging"
        # to one document "move" together
        test1$group_row <- test1$rad - test1$df

         test1$y_min <-
            test1$y_min + (row_distance * test1$group_row)
        test1$y_max <-
            test1$y_max + (row_distance * test1$group_row)

        ## DISTANCE BETWEEN TILES/DOCS HORIZONTALLY
        test1 <- test1 %>%
            dplyr::group_by(rad) %>%
            dplyr::mutate(position_in_row = (1:dplyr::n()) - 1) %>%
            dplyr::mutate(x_min = x_min + (position_in_row * horizontal_distance),
                          x_max = x_max + (position_in_row * horizontal_distance)) %>%
            dplyr::ungroup()
    }

    # DISTANCE BETWEEN YEARS/GROUPS
    test1$Year_numeric <- as.numeric(factor(test1$Year_, levels = unique(test1$Year_)))
    test1$y_min <- test1$y_min + (year_distance * test1$Year_numeric - min(test1$Year_numeric))
    test1$y_max <- test1$y_max + (year_distance * test1$Year_numeric - min(test1$Year_numeric))
    return(test1)
}
