if (search_arguments$all_ok == FALSE) {
    shiny::validate(shiny::need(
        check_search_term_length(c(search_arguments$terms_highlight,
                                   search_arguments$subset_terms))
        ,
        paste("\nSearch expression exceeds", CHARACTER_LIMIT, "character limit.")
    ))

    shiny::validate(shiny::need(
        check_regexes(c(search_arguments$terms_highlight,
                                   search_arguments$subset_terms))
        ,
        paste("\nInvalid regular expression. Please modify your search.")
    ))

    shiny::validate(shiny::need(
        all(check_safe_search(c(search_arguments$terms_highlight,
                                   search_arguments$subset_terms)))
        ,
        paste("\nThe search patterns will result in an enormous amount of hits or the search will run for a very long time, potentially infinitely.

If this is something you want, set 'allow_unreasonable_patterns' in 'run_corpus_explorer()' to 'TRUE'.")
    ))

    shiny::validate(shiny::need(
        check_valid_tresholds(isolate(search_arguments$raw_terms_highlight))
        ,
        paste(
            '\nTreshold argument invalid. Make sure it contains only numbers, e.g. "--4".'
        )
    ))

    if (!is.null(isolate(input$subset_corpus))) {
        if (isolate(input$subset_corpus == 'Yes')) {
            shiny::validate(shiny::need(
                check_valid_tresholds(isolate(search_arguments$raw_terms_subset))
                ,
                paste(
                    '\nTreshold argument invalid. Make sure it contains only numbers, e.g. "--4".'
                )
            ))
        }
    }

    shiny::validate(shiny::need(
        check_valid_column_names(
            c(
                search_arguments$custom_column,
                search_arguments$subset_custom_column
            ),
            session_variables$data_dok
        )
        ,
        paste("\nMake sure to specify only variables present in the corpus.")
    ))
}


shiny::validate(shiny::need(
    nrow(session_variables$data_dok) != 0
    ,
    paste("\nThe filtered corpus does not contain any documents.")
))

shiny::validate(shiny::need(
    length(search_arguments$search_terms) <= 2
    ,
    paste(
        "\nWorks currently with maximum two search terms. To highlight more terms in the documents, use the 'Add terms for text highlighting' option."
    )
))

shiny::validate(shiny::need(
    (nrow(session_variables[[plot_mode$mode]]) > MAX_DOCS_IN_WALL_VIEW
     & plot_mode$mode == "data_dok") == FALSE
    ,
    paste("\nCorpus map too large. Filter corpus or switch to calendar view.")
))
