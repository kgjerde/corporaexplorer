observe({
    if (nrow(sv$subset) > 400) {
        shinyjs::disable("download_html")
    }
    
})


observe({
    output$download_button_text_txt <-
        output$download_button_text_zip <- renderText({
            paste("Download",
                  nrow(sv$subset),
                  "documents")
        })
})

observe({
    output$download_button_text_html <- renderText({
        if (nrow(sv$subset) <= 400) {
            title <- paste("Download",
                           nrow(sv$subset),
                           "documents")
            if (!identical(search_arguments$highlight_terms, "")) {
                title <- paste(title, "with highlighted text")
            }
        } else {
            title <- "Too many documents (max 400)"
        }
        
        title
        
    })
})
