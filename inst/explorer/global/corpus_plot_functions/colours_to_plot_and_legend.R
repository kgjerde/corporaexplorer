# Main function -----------------------------------------------------------

#' Transforming count factors to colours, and legend
#'
#' @param main_df Full data frame.
#' @param linjer Number of search terms.
#' @param number_of_factors Number of factors for each search term.
#' @param search_terms_exist The answer to !identical(search_arguments$search_terms, "")
#' @param mode plot mode
#'
#' @return List of length 2: 1) df with column Term_colour for colour of each document/day, 2) df for legend.
colours_to_plot_and_legend <- function(main_df,
                                       linjer,
                                       number_of_factors = NUMBER_OF_FACTORS,
                                       search_terms_exist,
                                       plot_mode) {
  legend_df <- create_legend_df_step_1(main_df)

  colour_schemes <- define_colours(
    legend_df = legend_df,
    linjer = linjer,
    number_of_factors = number_of_factors,
    plot_mode = plot_mode
  )

  legend_df <-
    update_legend_df_w_colours(legend_df, colour_schemes)

  main_df <- populate_df_colour_codes(main_df, legend_df)

  legend_df <-
    add_dummy_colours_to_legend_df(
      legend_df,
      linjer,
      number_of_factors,
      search_terms_exist
    )

  main_df <- add_dummy_colours_to_main_df(main_df, legend_df)

  return(list(main_df, legend_df))
}

# Supporting functions ----------------------------------------------------

# Achieve "distance" between colours and avoid the very lightest ones
# Therefore different colour selections depending on number of factors
# Return chr length equalling length(number_of_factors)
define_indices_in_colour_palette <-
  function(number_of_factors) {
      fargeutvalg_vektor <- list(
        3,
        c(5, 9),
        c(3, 6, 9),
        c(3, 5, 7, 9),
        5:9,
        4:9,
        3:9,
        2:9
      )
    return(fargeutvalg_vektor[seq_len(number_of_factors)])
  }

# Lighter colours for day_corpus
define_indices_in_colour_palette_day <-
  function(number_of_factors) {
    fargeutvalg_vektor <- list(4,
                               c(4, 6),
                               4:6,
                               3:6)
    return(fargeutvalg_vektor[seq_len(number_of_factors)])
  }


create_legend_df_step_1 <-
  function(main_df) {
    legend_df <- tibble::tibble(
      legend_label = main_df$Term,
      factor_names = main_df$Term,
      colour_code = "placeholder"
    ) %>%
      dplyr::distinct() %>%
      dplyr::filter(!is.na(legend_label)) %>%
      dplyr::mutate(term = as.integer(stringr::str_extract(legend_label, "^\\d"))) %>% # = opp til ni terms
      dplyr::arrange(term) %>%
      dplyr::mutate(
        legend_label = stringr::str_replace(legend_label, "^\\d-", ""),
        for_sortering = as.integer(stringr::str_replace(legend_label, "-.*", ""))
      ) %>%
      dplyr::group_by(term) %>%
      dplyr::arrange(term, for_sortering) %>%
      dplyr::mutate(for_sortering = seq_len(dplyr::n())) %>%
      dplyr::mutate(id = paste0(term, "-", for_sortering))
    return(legend_df)
  }


number_of_labels_for_each_term <- function(legend_df, linjer) {
  factor_length_for_each_term <- integer(length(linjer))

  for (i in seq_len(linjer)) {
    factor_length_for_each_term[i] <- sum(legend_df$term == i)
  }

  return(factor_length_for_each_term)
}


define_colours <- function(main_colours = MAIN_COLOURS,
                           legend_df,
                           linjer,
                           number_of_factors,
                           plot_mode) {

  # TODO: this 'main_colours' value means max 6 search terms

  main_colours <- convert_colours_to_brewerpal_colours(main_colours)

  factor_length <- number_of_labels_for_each_term(legend_df, linjer)

  if (plot_mode == "day") {
    colour_index <-
      define_indices_in_colour_palette_day(number_of_factors)
  } else {
    colour_index <-
      define_indices_in_colour_palette(number_of_factors)
  }

  colour_schemes <- list()
  length(colour_schemes) <- linjer

  for (i in unique(legend_df$term)) {
    colour_schemes[[i]] <-
      RColorBrewer::brewer.pal(name = main_colours[i], 9)[colour_index[[factor_length[i]]]]
  }

  return(colour_schemes)
}

convert_colours_to_brewerpal_colours <- function(colours) {
  brewerpal_colours <- plyr::mapvalues(x = colours,
                                       from = c("red", "blue", "green", "purple", "orange", "gray"),
                                       to = c("Reds", "Blues", "Greens", "Purples", "Oranges", "Greys"),
                                       warn_missing = FALSE)
  return(brewerpal_colours)
}

update_legend_df_w_colours <- function(legend_df,
                                       colour_schemes) {

  # Add colour code to legend tibble
  unlisted_colour_schemes <- unlist(colour_schemes)

  if (!is.null(unlisted_colour_schemes)) {
    legend_df$colour_code <- unlisted_colour_schemes
  }
  return(legend_df)
}


populate_df_colour_codes <- function(main_df,
                                     legend_df) {
  main_df$Term_color <- # [!is.na(main_df$Term_color)]


    plyr::mapvalues(
      x = main_df$Term # [!is.na(main_df$Term_color)]
      ,
      from = legend_df$factor_names,
      to = legend_df$colour_code
    )
  # NA remains NA
  return(main_df)
}

# Keys for each term should start on new row in legend --------------------

discrepancy_in_legend_keys <- function(legend_df,
                                       linjer,
                                       number_of_factors) {
  max_possible_legend_keys <- linjer * number_of_factors
  actual_legend_keys <- nrow(legend_df)
  return(max_possible_legend_keys - actual_legend_keys)
}

need_to_add_dummy_colours <- function(legend_key_discrepancy,
                                      search_terms_exist) {
  return(search_terms_exist == TRUE & legend_key_discrepancy != 0)
}

add_dummy_colours_to_legend_df <-
  function(legend_df,
             linjer,
             number_of_factors,
             search_terms_exist) {
    legend_key_discrepancy <-
      discrepancy_in_legend_keys(
        legend_df,
        linjer,
        number_of_factors
      )

    need_for_dummies <-
      need_to_add_dummy_colours(
        legend_key_discrepancy,
        search_terms_exist
      )

    if (need_for_dummies == TRUE) {
      dummy_df <- create_temp_dummy_df(number_of_factors, linjer)
      legend_df <- merge_dfs(legend_df, dummy_df, number_of_factors)
    }
    return(legend_df)
  }

create_temp_dummy_df <- function(number_of_factors, linjer) {
  dummy_levels <- rgb(sprintf(
    "%i",
    seq_len(number_of_factors * linjer)
  ),
  0, 0,
  alpha = 0, maxColorValue = 255
  )

  dummy_df <- tibble::tibble(
    legend_label = " ",
    # factor_names = NA,
    colour_code = dummy_levels,
    term = sort(rep(
      seq_len(linjer),
      number_of_factors
    )),
    for_sortering = rep(
      seq_len(number_of_factors),
      linjer
    ),
    id = paste0(term, "-", for_sortering)
  )
  return(dummy_df)
}

merge_dfs <- function(legend_df, dummy_df, number_of_factors) {
  from_dummy <- dplyr::anti_join(dummy_df, legend_df, by = "id")

  from_dummy <- adapt_legend_keys_for_terms_with_no_hits(
    from_dummy,
    number_of_factors
  )

  legend_df <- dplyr::full_join(legend_df,
    from_dummy,
    by = c("legend_label", "colour_code", "term", "for_sortering", "id")
  ) %>%
    dplyr::arrange(term, for_sortering)
  return(legend_df)
}

adapt_legend_keys_for_terms_with_no_hits <-
  function(from_dummy,
             number_of_factors) {
    terms_w_no_hits <- from_dummy %>%
      dplyr::group_by(term) %>%
      dplyr::summarise(lengde = dplyr::n()) %>%
      dplyr::filter(lengde == number_of_factors) %>%
      .$term

    if (length(terms_w_no_hits) > 0) {

      # This can be used if I want to exclude the terms with no hits from the legend:
      # from_dummy <- from_dummy %>%
      #   dplyr::filter(term != terms_w_no_hits)
      # browser()

      from_dummy <- from_dummy %>%
        dplyr::group_by(term) %>%
        dplyr::mutate(legend_label = dplyr::if_else(term %in% terms_w_no_hits & dplyr::row_number() == 1, "No hits", legend_label))

      from_dummy$colour_code[from_dummy$legend_label == "No hits"] <- MY_COLOURS[from_dummy$term[from_dummy$legend_label == "No hits"]]
    }
    return(from_dummy)
  }


add_dummy_colours_to_main_df <- function(main_df, legend_df) {
  main_df$Term_color <- factor(main_df$Term_color,
    levels = legend_df$colour_code
  )
  return(main_df)
}
