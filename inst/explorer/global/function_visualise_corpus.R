source("./global/corpus_plot_functions/colours_to_plot_and_legend.R", local = TRUE)
source("./global/corpus_plot_functions/count_search_terms_hits.R", local = TRUE)
source("./global/corpus_plot_functions/create_coordinates_several_terms.R", local = TRUE)
source("./global/corpus_plot_functions/create_factors_for_labelling.R", local = TRUE)
source("./global/corpus_plot_functions/label_axes.R", local = TRUE)

source("./global/corpus_plot_functions/create_coordinates_1_data_365.R", local = TRUE)
source("./global/corpus_plot_functions/create_distance_coordinates_365.R", local = TRUE)
source("./global/corpus_plot_functions/plotting_corpus_data_365.R", local = TRUE)

source("./global/corpus_plot_functions/create_coordinates_1_data_dok.R", local = TRUE)
source("./global/corpus_plot_functions/create_distance_coordinates_dok.R", local = TRUE)
source("./global/corpus_plot_functions/plotting_corpus_data_dok.R", local = TRUE)

source("./global/corpus_plot_functions/create_distance_coordinates_day.R", local = TRUE)
source("./global/corpus_plot_functions/plotting_corpus_day.R", local = TRUE)

#' Corpus map/plot constructor
#'
#' The main function for creation of corpus maps in three different formats:
#' calendar view, document brick wall view, and 'a day in the corpus' view (when
#' a is clicked in calendar view).
#' @param df A data frame corresponding to the plot mode (data_365 or
#'   data_dok).
#' @param .width Max width of x axis in plot.
#' @param matriksen Corpus matrix.
#' @param ordvektor Corpus word vector.
#' @param number_of_factors Max number of groups for labelling of search term
#'   hits.
#' @param doc_df The data_dok data frame, invoked for search if modus ==
#'   "data_365".
#' @param search_arguments List containing search arguments.
#' @param modus One of "data_365", "data_dok", or "day".
#'
#' @return A ggplot2 plot object.
visualiser_korpus <-
  function(df,
           .width = "auto",
           matriksen = loaded_data$original_matrix$data_dok,
           ordvektor = loaded_data$ordvektorer$data_dok,
           number_of_factors = NUMBER_OF_FACTORS,
           doc_df,
           search_arguments,
           modus) {
    linjer <- length(search_arguments$search_terms)

# 1. Check if search contains search terms --------------------------------

    if (identical(search_arguments$search_terms, "")) {
      df$Term_1 <- NA
    } else {

# 2. Count search term hits -----------------------------------------------
local_flag <- FALSE
if (INCLUDE_EXTRA == TRUE) {
  if (search_arguments$extra_plot != "regular") {
    linjer <- 1
    search_arguments$search_terms <- "PLACEHOLDER"
    local_flag <- TRUE
    count_overview <- cx_extra_chart(search_arguments$extra_chart_terms,
                                     doc_df,
                                     df,
                                     search_arguments$case_sensitive,
                                     modus)
  }

  # The regular one:
  if (local_flag == FALSE) {
    count_overview <-
      count_search_terms_hits(
        df,
        search_arguments,
        matriksen,
        ordvektor,
        doc_df,
        modus
      )
  }
}

# 3. Assign factors for labelling -----------------------------------------

      df <- create_factors_for_labelling(count_overview,
        df,
        search_terms = search_arguments$search_terms,
        number_of_factors
      )
    }

# 4. Create plot coordinates, step 1 --------------------------------------

    if (modus == "data_365") {
      # width = 53 # fordi uker
      df$Month <- lubridate::month(df$Date)
      df$label_id <- seq_len(nrow(df))
      df <- create_coordinates_1_data_365(df)
    } else if (modus == "data_dok") {
      df <- create_coordinates_1_data_dok(df, linjer)
    } else if (modus == "day") {
      df <- create_coordinates_1_data_dok(df, linjer, max_width_for_row = 15)
    }

# 5. Create plot coordinates, step 2 (if search terms > 1) ----------------

    df <-
      create_coordinates_several_search_terms(df, linjer)
    df <- dplyr::select(df, -dplyr::starts_with("Term_"))

# 6. Create plot coordinates, step 3 (distance between days etc.) ---------

    if (modus == "data_365") {
      df <- create_distance_coordinates_365(
        df,
        linjer,
        day_distance,
        month_distance,
        year_distance
      )
    } else if (modus == "data_dok") {
      df <- create_distance_coordinates_dok(
        df,
        linjer
      )
    } else if (modus == "day") {
      df <- create_distance_coordinates_day(
        df,
        linjer,
        day_distance
      )
    }

# 7. Label x and y axes ---------------------------------------------------
    y_text <- label_y_axis(df)

    if (modus == "data_365") {
      x_breaks <- label_x_axis_365(df)
    }

# 8. Assign colours to plot labels/factors (up to 2 terms) ----------------

    temp_variable_for_unpacking <-
      colours_to_plot_and_legend(df,
        linjer,
        number_of_factors,
        !identical(search_arguments$search_terms, ""),
        plot_mode = modus
      )
    df <- temp_variable_for_unpacking[[1]]
    legend_df <- temp_variable_for_unpacking[[2]]

# 9. ggplotting -----------------------------------------------------------

    if (modus == "data_365") {
      plotting_corpus_data_365(df, x_breaks, y_text, legend_df, linjer)
    } else if (modus == "data_dok") {
      plotting_corpus_data_dok(df, y_text, legend_df, linjer)
    } else if (modus == "day") {
      plotting_corpus_day(df, linjer)
    }
  }
