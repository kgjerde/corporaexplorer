shiny::updateTabsetPanel(session, inputId = "dokumentboks", selected = 'document_box_title')


if (session_variables$doc_list_open == TRUE) {
    shiny::removeTab('dokumentboks',
              target = "document_list_title",
              session = shiny::getDefaultReactiveDomain())



    session_variables$doc_list_open <- FALSE
}


if (session_variables$doc_tab_open == FALSE) {
    shiny::appendTab(
        'dokumentboks',
        tab =
            tabPanel(
                title = shiny::textOutput('document_box_title'),
                value = "document_box_title",
                shiny::plotOutput("dok_vis",
                           click = "dok_vis_click",
                           height = "auto"),

                shiny::htmlOutput(
                    outputId = "doc_tekst",
                    container = shiny::tags$div,
                    class = "boxed_doc"
                )
            ),

        select = TRUE,
        menuName = NULL,
        session = shiny::getDefaultReactiveDomain()
    )

    appendTab(
        'dokumentboks',
        tab =
            shiny::tabPanel(
                title = shiny::textOutput('document_box_title_info'),
                value = "document_box_title_info",

                shiny::htmlOutput(
                    outputId = "doc_info",
                    container = shiny::tags$div,
                    class = "boxed_doc"
                )

            )
    )

    # Setter fane-tittel
    output$document_box_title_info <- shiny::renderText({
        paste0("Document information")
    })

    session_variables$doc_tab_open <- TRUE

}

show_ui("document_box")

# Setter boks-tittel
output$document_box_title <- shiny::renderText({
    paste0("Document \u2013 ",
           format_date(
               session_variables[[plot_mode$mode]]$Date[min_rad])
           )
})
