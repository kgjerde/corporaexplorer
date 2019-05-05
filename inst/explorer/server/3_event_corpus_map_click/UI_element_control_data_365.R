if (session_variables$doc_tab_open == TRUE) {
    shiny::removeTab('dokumentboks',
              target = "document_box_title",
              session = shiny::getDefaultReactiveDomain())
    shiny::removeTab('dokumentboks',
              target = "document_box_title_info",
              session = shiny::getDefaultReactiveDomain())


    session_variables$doc_tab_open <- FALSE

}

if (session_variables$doc_list_open == FALSE) {
    shiny::appendTab(
        'dokumentboks',
        tab =
            shiny::tabPanel(
                title = shiny::textOutput('document_list_title'),
                value = "document_list_title",
                htmlOutput(
                    outputId = "doc_list_tekst",
                    container = tags$div,
                    class = "boxed_doc_data_365"
                )
            ),

        select = TRUE,
        menuName = NULL,
        session = shiny::getDefaultReactiveDomain()
    )

    session_variables$doc_list_open <- TRUE

} else if (session_variables$doc_list_open == TRUE) {
    shiny::updateTabsetPanel(session,
                      inputId = "dokumentboks",
                      selected = 'document_list_title')
}

# Viser dag_kart og dokumentboks
show_ui("day_corpus_box")
show_ui("document_box")

# Setter tab-tittel
output$document_list_title <- shiny::renderText({
    "Document list"
})



# Setter boks-tittel
output$title <- shiny::renderText({
    format_date(session_variables[[plot_mode$mode]]$Date[min_rad])
})

# Setter boks-tittel
output$document_box_title <- shiny::renderText({
    "Document list"
})
