# "Reset" corpus before each search ---------------------------------------
session_variables$data_365 <-
  loaded_data$original_data$data_365
session_variables$data_dok <-
  loaded_data$original_data$data_dok
# Og nullstiller subset-flagg
search_arguments$subset_search <- FALSE
# Og korpusinfofanebesøk
session_variables$created_info <- FALSE
# Og dokumentinfo-fane
session_variables$doc_tab_open <- FALSE
# Og info_tab validation flag
session_variables$stop_info_tab <- TRUE

# And corpus info plot
session_variables$corpus_info_plot <- NULL


# Collect search arguments from sidebar -----------------------------------

# Calendar or document wall -----------------------------------------------
previous_mode <- plot_mode$mode
# For non-date-based corpora, Plot mode panel is hidden so input$modus doesn't exist
plot_mode$mode <- if (DATE_BASED_CORPUS) input$modus else "data_dok"

# Save state change in order to update only when changed
if (previous_mode != plot_mode$mode) {
  plot_mode$changed <- TRUE
} else {
  plot_mode$changed <- FALSE
}

# Time --------------------------------------------------------------------
if (DATE_BASED_CORPUS == TRUE) {
  # Handle case where date inputs might not be initialized (accordion not opened)
  if (!is.null(input$years_or_dates) && !is.null(input$date_slider)) {
    search_arguments$time_filtering_mode <- input$years_or_dates
    if (search_arguments$time_filtering_mode == "Year range") {
      search_arguments$time_range <- input$date_slider[
        1
      ]:input$date_slider[2]
    } else if (
      search_arguments$time_filtering_mode == "Date range" &&
        !is.null(input$date_calendar)
    ) {
      search_arguments$time_range <- c(
        input$date_calendar[1],
        input$date_calendar[2]
      )
    }
  } else {
    # Default to full year range if accordion not opened yet
    search_arguments$time_filtering_mode <- "Year range"
    year_range <- range(loaded_data$original_data$data_dok$Year_)
    search_arguments$time_range <- year_range[1]:year_range[2]
  }
}

# Case sensitive? ---------------------------------------------------------
search_arguments$case_sensitive <- input$case_sensitivity

# Filtering corpus --------------------------------------------------------
# Check if filter_text_area has content instead of checkbox
filter_area <- input$filter_text_area
if (!is.null(filter_area) && nchar(trimws(filter_area)) > 0) {
  search_arguments$subset_search <- TRUE
  search_arguments$raw_subset_terms <- collect_subset_terms() # For later argument check
  search_arguments$subset_thresholds <- collect_threshold_values(
    search_arguments$raw_subset_terms
  )
  search_arguments$subset_custom_column <- collect_custom_column(
    search_arguments$raw_subset_terms
  )
  search_arguments$subset_terms <-
    to_lower_if_case_insensitive_search(
      search_arguments$raw_subset_terms
    ) %>%
    clean_terms()
} else {
  # "Resetting" variables if no filtering:
  search_arguments$subset_search <- FALSE
  search_arguments$subset_terms <- NULL
  search_arguments$subset_thresholds <- NA
  search_arguments$subset_custom_column <- NA
  search_arguments$raw_subset_terms <- character(0)
}

# Search terms ------------------------------------------------------------
search_arguments$search_terms <- collect_search_terms() %>%
  to_lower_if_case_insensitive_search() %>%
  clean_terms()

#  Highlight terms - collect and keep raw for later argument check---------
search_arguments$raw_highlight_terms <- collect_highlight_terms()

# Highlight terms --------------------------------------------------------
search_arguments$terms_highlight <- search_arguments$raw_highlight_terms %>%
  to_lower_if_case_insensitive_search() %>%
  clean_terms()

# Search arguments for all terms (search terms and highlight terms) -------
search_arguments$thresholds <- collect_threshold_values(
  search_arguments$raw_highlight_terms
)
search_arguments$custom_column <- collect_custom_column(
  search_arguments$raw_highlight_terms
)

# Prepend search terms to filter if checkbox is checked -------------------
# Re-processes combined terms for simplicity; duplication is negligible
if (
  isTRUE(input$filter_by_search_terms) &&
    length(search_arguments$raw_highlight_terms) > 0
) {
  combined_raw <- c(
    search_arguments$raw_highlight_terms,
    search_arguments$raw_subset_terms
  ) %>%
    unique()
  search_arguments$subset_search <- TRUE
  search_arguments$raw_subset_terms <- combined_raw
  search_arguments$subset_thresholds <- collect_threshold_values(combined_raw)
  search_arguments$subset_custom_column <- collect_custom_column(combined_raw)
  search_arguments$subset_terms <- combined_raw %>%
    to_lower_if_case_insensitive_search() %>%
    clean_terms()
}

# Checking search arguments -----------------------------------------------
search_arguments$all_ok <- check_all_input()

# Extra session variables -------------------------------------------------
if (INCLUDE_EXTRA == TRUE) {
  cx_extra_reset_data()

  search_arguments$extra_plot <- input$extra_plot_mode
  search_arguments$extra_chart_terms <- input$magic_search_area %>%
    stringr::str_split("\n") %>%
    unlist(use.names = FALSE) %>%
    unique()

  # HACKY TODO. This is because otherwise an empty field is character(0) instead of "" and fails cx_validate_input
  if (length(search_arguments$extra_chart_terms) > 1) {
    search_arguments$extra_chart_terms <-
      search_arguments$extra_chart_terms[
        !stringi::stri_isempty(search_arguments$extra_chart_terms)
      ]
  }

  if (
    !identical(search_arguments$extra_chart_terms, "") &
      search_arguments$extra_plot != "regular"
  ) {
    search_arguments$search_terms <- sprintf(
      "PLACEHOLDER",
      seq_along(search_arguments$extra_chart_terms)
    )
  }
}
