sv <- reactiveValues(filelist = NULL,
                     subset = abc,
                     message = NULL)

search_arguments <- reactiveValues(
    subset_terms = NA,
    case_sensitive = FALSE,
    subset_thresholds = NA,
    subset_custom_column = NA,
    highlight_terms = NA
)

