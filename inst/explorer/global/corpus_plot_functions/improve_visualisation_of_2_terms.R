#' Better visualise searches with 2 search terms
#'
#' @param df
#' @param number_of_search_terms
#'
#' @return data frame
improve_visualisation_of_2_terms <-
    function(df_, number_of_search_terms) {
        if (number_of_search_terms == 2) {
            df_ <- df_ %>%
                dplyr::group_by(cx_ID) %>%
                dplyr::mutate(colour_of_other_search_term = dplyr::if_else(
                    condition = df == 1,
                    true = Term_color[df == 2],
                    false = Term_color[df == 1]
                )) %>%
                dplyr::ungroup()
            # Replacing "no fill" with fill of "other half"
            df_$Term_color[is.na(df_$Term_color)] <-
                df_$colour_of_other_search_term[is.na(df_$Term_color)]
        }
        return(df_)
    }
# Special feature when two search terms:
# Fills up entire tile when only one
# term is present in document/day.
# If both terms present, each get half the tile
## Identifying, when multi-term search,
## which tiles are occupied by only one search term
## and fill the whole tile
## (i.e. prepare the df)
## with the corresponding fill:
