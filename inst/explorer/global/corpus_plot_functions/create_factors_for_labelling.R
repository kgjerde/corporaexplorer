#' Wrapper/loop function for label_gruppering()
create_factors_for_labelling <-
    function(count_oversikt,
             df,
             search_terms,
             number_of_factors) {
        # Samennslåing og faktor-ordning (til fargeinndeling og label)
        # Arbitrært antall søketermer
        # Fancy dplyr for assigning strings as column names
        for (i in seq_along(search_terms)) {
            kolonnenavn <- paste0("Term_", i)
            df <-
                dplyr::bind_cols(
                    df,
                    !!kolonnenavn := label_gruppering(count_oversikt, kolonnenavn, i, number_of_factors)
                )
        }
        return(df)
    }

#' Grouping counts into categories and assignign labels
#'
#' @param df Df with counts for each search term. Produced by
#'   count_search_terms_hits().
#' @param column_name Character. Term_1, Term_2, etc
#' @param prefix Character to distinguish between factors produced for different
#'   search terms. Typically produced by loop in count_search_terms_hits().
#' @param number_of_factors Integer. How many factors should the counts be
#'   divided into?
#'
#' @return Vector with factor/category for a search term. E.g. c("<NA>",
#'   "1-1-2").
label_gruppering <- function(df, column_name, prefix, number_of_factors = NUMBER_OF_FACTORS) {
  df[column_name][df[column_name] == 0] <- NA

  if (length(unique(df[column_name][!is.na(df[column_name])])) > 1) {
    # altså ikke nøyaktig én dag med treff eller bare én verdi på flere dager
    # create a new variable from incidence
    df$treff_faktor <- cut(
      df[[column_name]],
      breaks = stats::quantile(
        unique(df[[column_name]]),
        probs =
          seq(0, 1, by = 1 / number_of_factors),
        na.rm = TRUE
      ),
      include.lowest = TRUE # labels = 1:7
    )


    # change level order
    df$treff_faktor <- factor(as.character(df$treff_faktor),
      levels = rev(levels(df$treff_faktor))
    )

    nivaaer <- levels(df$treff_faktor)

    del_1 <- stringr::str_replace_all(nivaaer, "\\(|\\[|\\]|,.*", "") %>%
      as.numeric()

    # For å få unngått sammenfallende kategorier i legend. (Men ikke for den første, den
    # begynner på det laveste)
    del_1[1:length(nivaaer) - 1] <-
      del_1[1:length(nivaaer) - 1] + 0.0000000000001
    del_1 <- ceiling(del_1)

    del_2 <- stringr::str_replace_all(nivaaer, "\\(|\\[|\\]|.*,", "") %>%
      as.numeric() %>%
      floor()

    nytt_nivaaer <- paste0(del_1, "-", del_2)

    # For å unngå legender som "7-7"
    nytt_nivaaer[del_1 - del_2 == 0] <- del_1[del_1 - del_2 == 0]

    df$faktorer <-
      plyr::mapvalues(df$treff_faktor, nivaaer, nytt_nivaaer)
  } else {
    # altså kun én dag med treff eller bare én verdi på flere dager
    df$faktorer <-
      factor(df[[column_name]], levels = unique(df[[column_name]]))
  }

  # Setter prefiks for å skille mellom ulike søkeord
  # na-sjekk Fordi ting ellers gikk skeis når ingen treff
  # if(!is.na(unique(levels(aaa2$faktorer)))){
  if (length(levels(df$faktorer)) != 0) {
    add_prefix <- function(x) {
      paste(prefix, x, sep = "-")
    }
    df$faktorer <- forcats::fct_relabel(df$faktorer, add_prefix)
  }

  return(df$faktorer)
}
