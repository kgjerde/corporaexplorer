# Document text -----------------------------------------------------------
output$doc_tekst <- shiny::renderText({
    display_document(
        shiny::isolate(session_variables$data_day$Text_original_case[min_rad]),
                     search_arguments)
})

# Document visualisation --------------------------------------------------
if (length(search_arguments$terms_highlight) > 0) {
    output$dok_vis <- shiny::renderPlot({
        result <- visualiser_dok(shiny::isolate(session_variables$data_day[min_rad, ]),
                       search_arguments$terms_highlight,
                       search_arguments$case_sensitive)
        shiny::req(result)
        result
    }, height = function(x) {
        if (length(search_arguments$terms_highlight) == 0) {
            1
        } else{
            (30 + (length(search_arguments$terms_highlight) * 25))
        }
    })
}
