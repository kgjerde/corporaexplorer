
shiny::validate(shiny::need(
    check_regexes(c(search_arguments$highlight_terms,
                               search_arguments$subset_terms))
    ,
    paste("\nInvalid regular expression. Please modify your search.")
))

shiny::validate(need(
    check_valid_column_names(search_arguments$subset_custom_column, sv$subset)
    ,
    paste("Make sure to specify only variables present in the corpus.")
))

shiny::validate(need(
    contains_argument(search_arguments$highlight_terms) == FALSE
    ,
    paste('Search arguments ("--") work only for subsetting.')
))

shiny::validate(need(
    contains_only_valid_thresholds(isolate(collect_subset_terms()))
    ,
    paste(
        'Treshold argument invalid. Make sure it contains only numbers, e.g. "--4".'
    )
))

if (nrow(sv$subset) > 0) {
    shinyjs::enable("download_txt")
    shinyjs::enable("download_zip")

if (nrow(sv$subset) <= MAX_DOCS_FOR_HTML) {
    shinyjs::enable("download_html")
}
}
