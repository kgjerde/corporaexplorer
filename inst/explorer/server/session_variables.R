session_variables <- shiny::reactiveValues(
    data_day = NULL,
    plot_build_info = NULL,
    plotinfo_dag = NULL,
    data_365 = loaded_data$original_data$data_365,
    data_dok = loaded_data$original_data$data_dok,
    doc_tab_open = FALSE,
    doc_list_open = FALSE,
    created_info = FALSE,
    stop_info_tab = TRUE,
    day_plot_height = EMPTY_DAY_PLOT_HEIGHT,
    corpus_info_plot = NULL,
    plot_size = INITIAL_PLOT_SIZE
)

search_arguments <- shiny::reactiveValues(
    subset_search = FALSE,
    subset_terms = NULL,
    subset_thresholds = NA,
    subset_custom_column = NA,
    raw_subset_terms = character(0), # TODO unsatisfcactory
    search_terms = "",
    thresholds = NA,
    custom_column = NA,
    terms_highlight = character(0),
    raw_highlight_terms = character(0), # TODO unsatisfcactory
    case_sensitive = FALSE,
    time_filtering_mode = "Year range",
    time_range = min(loaded_data$original_data$data_dok$Year_):max(loaded_data$original_data$data_dok$Year_),
    all_ok = TRUE
)

plot_mode <- shiny::reactiveValues(mode = if (DATE_BASED_CORPUS == FALSE) "data_dok" else "data_365")

ui_elements <- shiny::reactiveValues(
    day_corpus_box = ".class_day_corpus",
    document_box = ".class_doc_box > .card, .class_doc_box > .bslib-card"
)
