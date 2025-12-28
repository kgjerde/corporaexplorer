shiny::updateTabsetPanel(session, inputId = "dokumentboks", selected = 'document_box_title')


if (session_variables$doc_list_open == TRUE) {

    remove_tab_doc_list_tekst()

    session_variables$doc_list_open <- FALSE
}


if (session_variables$doc_tab_open == FALSE) {

    add_tab_doc_tekst("dok")
    add_tab_doc_info("dok")
    if (INCLUDE_EXTRA == TRUE) {
        add_tab_extra("dok")
    }

    # Setter fane-tittel
    output$document_box_title_info <- shiny::renderText({
        paste0("Document information")
    })

    session_variables$doc_tab_open <- TRUE

}

show_ui("document_box")

# Setter box title -- depending on whether DATE_BASED_CORPUS or not
output$document_box_title <- shiny::renderText({

    if (DATE_BASED_CORPUS == TRUE) {
        paste0("Document \u2013 ",
               format_date(
                   session_variables[[plot_mode$mode]]$Date[min_rad])
               )
    } else if (DATE_BASED_CORPUS == FALSE) {
        doc_title_non_date_based_corpora(min_rad)
    }
})
