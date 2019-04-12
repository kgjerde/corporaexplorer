if (session_variables$doc_tab_open == FALSE) {
    shiny::appendTab(
        'dokumentboks',
        tab =
            shiny::tabPanel(
                title = textOutput('document_box_title'),
                value = "document_box_title",
                shiny::plotOutput("dok_vis",
                           click = "dok_vis_click",
                           height = "auto"),
                
                shiny::htmlOutput(
                    outputId = "doc_tekst",
                    container = tags$div,
                    class = "boxed_doc"
                )
            ),
        
        select = TRUE,
        menuName = NULL,
        session = shiny::getDefaultReactiveDomain()
    )
    
    shiny::appendTab(
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
                
            ),
        
        
        select = FALSE,
        menuName = NULL,
        session = shiny::getDefaultReactiveDomain()
    )
    
    
    
    session_variables$doc_tab_open <- TRUE
    
} else if (session_variables$doc_tab_open == TRUE) {
    shiny::updateTabsetPanel(session, inputId = "dokumentboks", selected = 'document_box_title')
}



# Setter fane-tittel
output$document_box_title <- shiny::renderText({
    paste0("Document ",
           min_rad,
           " \u2013 ",
           "Text")
})

# Setter fane-tittel
output$document_box_title_info <- shiny::renderText({
    paste0("Document ",
           min_rad,
           " \u2013 ",
           "Information")
}
)
