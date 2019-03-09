session_variables <- shiny::reactiveValues(
    data_day = NULL,
    plot_build_info = NULL,
    plotinfo_dag = NULL,
    data_365 = loaded_data$original_data$data_365,
    data_dok = loaded_data$original_data$data_dok,
    doc_tab_open = FALSE,
    doc_list_open = FALSE,
    created_info = FALSE,
    stop_info_tab = TRUE
)

search_arguments <- shiny::reactiveValues(
    subset_search = FALSE,
    subset_terms = NULL,
    subset_tresholds = NA,
    subset_custom_column = NA,
    search_terms = "",
    tresholds = NA,
    custom_column = NA,
    terms_highlight = character(0),
    case_sensitive = FALSE,
    time_filtering_mode = "Year range",
    time_range = NA,
    raw_terms_highlight = character(0), # TODO unsatisfcactory
    raw_terms_subset = character(0), # TODO unsatisfcactory
    all_ok = TRUE
)

plot_mode <- shiny::reactiveValues(mode = "data_365")

ui_elements <- shiny::reactiveValues(
    day_corpus_box = ".class_day_corpus .nav-tabs-custom",
    show_day_corpus_box = FALSE,
    document_box = ".class_doc_box .nav-tabs-custom",
    show_document_box = FALSE
)
