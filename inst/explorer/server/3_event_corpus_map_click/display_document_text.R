output$doc_tekst <- shiny::renderText({
    display_document(session_variables[[plot_mode$mode]]$Text_original_case[min_rad],
                     search_arguments)
})
