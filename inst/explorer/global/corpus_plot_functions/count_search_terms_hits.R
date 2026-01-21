#' Bind counts for 1 or more search terms together
#'
#' Params as in visualiser_korpus().
#' 1) Creates empty df.
#' 2) Loop with count_hits_for_each_search_term().
#' 3) Included each count in df.
#' 4) Assigns Term_1, Term_2 etc. as column names.
#'
#' @return Df with ncol(df) == antall søkeord.
count_search_terms_hits <-
  function(
    .data,
    search_arguments,
    matriksen,
    ordvektor,
    doc_df,
    modus,
    terms = NULL
  ) {
    lengde <- rep(NA, times = nrow(.data))

    if (is.null(terms)) {
      terms <- search_arguments$search_terms
    }

    count_oversikt <-
      tibble::tibble(dummy_kolonne = lengde)

    for (i in seq_along(terms)) {
      count_oversikt <- cbind(
        count_oversikt,
        count_hits_for_each_search_term(
          terms[i],
          matriksen,
          .data,
          ordvektor,
          search_arguments$subset_search,
          search_arguments$case_sensitive,
          search_arguments$thresholds[i],
          doc_df,
          modus,
          search_arguments$custom_column[i]
        )
      )
    }

    colnames(count_oversikt) <-
      c("dummy_kolonne", paste0("Term_", seq_along(terms)))
    count_oversikt <- dplyr::select(count_oversikt, -dummy_kolonne)
  }
