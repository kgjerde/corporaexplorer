#' Better visualise searches with 2 search terms
#'
#' @param df
#' @param number_of_search_terms
#'
#' @return data frame
improve_visualisation_of_2_terms <- function(df, number_of_search_terms) {
    if (number_of_search_terms == 2) {
        fill_farge_chr <- as.character(df$Term_color)
        for (i in unique(df$cx_ID)) {
            # Are there search hits for any term here?
            all_fills <- fill_farge_chr[df$cx_ID == i]  ## FORENKL/SPEED UP DENNE. TROR DET ER DUMT MED LOOP
            # Sjekker om det er 1 treff:
            if (sum(is.na(all_fills)) == 1) {
                # Hvilken df (half of tile dedicated to search term) er tom?
                tom_df <- which(is.na(all_fills))
                ikke_tom_df  <- if (tom_df == 1)
                    2
                else
                    1
                df$Term_color[df$cx_ID == i &
                                  df$df == tom_df] <-
                    df$Term_color[df$cx_ID == i &
                                      df$df == ikke_tom_df]
            }
        }
    }
    return(df)
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
