if (search_arguments$all_ok == FALSE) {

    validate_search_term_length()
    validate_regexes()
    validate_safe_search()

    validate_thresholds(isolate(search_arguments$raw_highlight_terms))

    if (!is.null(isolate(input$subset_corpus))) {
        if (isolate(input$subset_corpus == 'Yes')) {
            validate_thresholds(isolate(search_arguments$raw_subset_terms))
        }
    }

    validate_column_names()

}

shiny::validate(shiny::need(
    nrow(session_variables$data_dok) != 0
    ,
    paste("\nThe filtered corpus does not contain any documents.")
))

validate_max_docs_in_wall()
