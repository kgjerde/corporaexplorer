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


# Collect search arguments from sidebar -----------------------------------

plot_mode$mode <- input$modus

search_arguments$time_filtering_mode <- input$years_or_dates

if (search_arguments$time_filtering_mode == "Year range") {
    search_arguments$time_range <- input$date_slider[1]:input$date_slider[2]
} else if (search_arguments$time_filtering_mode == "Date range") {
    search_arguments$time_range <- c(input$date_calendar[1], input$date_calendar[2])
}

search_arguments$case_sensitive <- input$case_sensitivity

if (!is.null(input$subset_corpus)) {
    search_arguments$subset_terms <- collect_subset_terms()
    search_arguments$subset_tresholds <-collect_treshold_values(search_arguments$subset_terms)
    search_arguments$subset_custom_column <- collect_custom_column(search_arguments$subset_terms)
    search_arguments$subset_terms <- clean_terms(search_arguments$subset_terms)
}

search_arguments$search_terms <- collect_search_terms()
search_arguments$search_terms <- clean_terms(search_arguments$search_terms)

search_arguments$terms_highlight <- collect_highlight_terms()

search_arguments$tresholds <- collect_treshold_values(search_arguments$terms_highlight)
search_arguments$custom_column <- collect_custom_column(search_arguments$terms_highlight)

search_arguments$terms_highlight <- clean_terms(search_arguments$terms_highlight)

search_arguments$all_ok <- check_all_input()
