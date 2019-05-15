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
                                        row_distance = 0.3,
                                        year_distance = 1
                                        ){
    # DISTANCE BETWEEN DOCS VERTICALLY IF SEVERAL SEARCH TERMS
    # TODO This will work only for 2 search terms.
    if (linjer == 2) {
        test1$group_row <- dplyr::case_when(test1$rad %% 2 == 0 ~ test1$rad - 1,
                                            test1$rad %% 2 != 0 ~ test1$rad)
        test1$y_min <-
            test1$y_min + (row_distance * test1$group_row - 1)
        test1$y_max <-
            test1$y_max + (row_distance * test1$group_row - 1)
    }

    # DISTANCE BETWEEN YEARS/GROUPS
    test1$Year_numeric <- as.numeric(factor(test1$Year, levels = unique(test1$Year)))
    test1$y_min <- test1$y_min + (year_distance * test1$Year_numeric - min(test1$Year_numeric))
    test1$y_max <- test1$y_max + (year_distance * test1$Year_numeric - min(test1$Year_numeric))
    return(test1)
}
