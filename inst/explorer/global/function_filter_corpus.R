#' Filter corpus by years or dates
#'
#' @param .tibble Corpus data frame.
#' @param search_arguments For date range and "range type"
#'
#' @return Filtered data frame.
filtrere_korpus_tid <-
  function(.tibble, search_arguments, plot_mode) {
    if (search_arguments$time_filtering_mode == "Year range") {
      # Simple filtering
      filtrert_tibble <-
        .tibble[.tibble$Year_ %in% search_arguments$time_range, ]
      return(filtrert_tibble)
    } else if (search_arguments$time_filtering_mode == "Date range") {
      start_date <- search_arguments$time_range[1]
      end_date <- search_arguments$time_range[2]
      if (plot_mode == "data_365") {
        # Not removing dates outside of the range but in the same year,
        # but rendering them empty/outside of corpus:
        # Identifying:
        ikke_i_subset_indekser <- which(
          (.tibble$Date >= first_day_in_year(start_date) &
            .tibble$Date < start_date) |
            (.tibble$Date > end_date &
              .tibble$Date <= last_day_in_year(end_date))
        )
        # Rendering "empty"
        .tibble$Day_without_docs[ikke_i_subset_indekser] <- TRUE
        .tibble$Invisible_fake_date[ikke_i_subset_indekser] <- TRUE
        # And then filtering.
        filtrert_tibble <-
          .tibble[
            .tibble$Date >= first_day_in_year(start_date) &
              .tibble$Date <= last_day_in_year(end_date),
          ]
      } else if (plot_mode == "data_dok") {
        filtrert_tibble <-
          .tibble[
            .tibble$Date >= start_date & .tibble$Date <= end_date,
          ]
      }
      return(filtrert_tibble)
    }
  }

# Helper functions
first_day_in_year <- function(date) {
  return(lubridate::floor_date(date, unit = "year"))
}

last_day_in_year <- function(date) {
  return(lubridate::ceiling_date(date, unit = "year") - 1)
}

#' Subset/filter corpus by patterns
#'
#' This has to be refactored. Ugly use with additonal conditionals below.
#'
#' @param df Corpus data frame in correspondence with @param modus.
#' @param search_arguments A reactiveValues object with search arguments
#'   (including $subset_terms).
#' @param modus Either "data_365" or "data_dok".
#'
#' @return Filtered coprus df
filtrere_korpus_pattern <- function(
  df,
  search_arguments,
  modus,
  session_variables
) {
  new_df <- df
  for (i in seq_along(search_arguments$subset_terms)) {
    treff <-
      count_hits_for_each_search_term(
        search_arguments$subset_terms[i],
        matriks = loaded_data$original_matrix$data_dok,
        new_df,
        ordvektor = loaded_data$ordvektorer$data_dok,
        subset_search = TRUE,
        search_arguments$case_sensitive,
        search_arguments$subset_thresholds[i],
        doc_df = session_variables$data_dok,
        modus = modus,
        custom_column = search_arguments$subset_custom_column[i]
      )

    if (modus == "data_dok") {
      # Subsetting the tibble
      if (nrow(new_df) != 0) {
        new_df <- new_df[treff[[1]] > 0, ]
      }
    }

    if (nrow(new_df) == 0) {
      # For å ikke sette igang subseeting av tom df
      return(new_df)
    }
  }
  return(new_df)
}
