observe({
    if (nrow(sv$subset) > MAX_DOCS_FOR_HTML) {
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
        if (nrow(sv$subset) <=  MAX_DOCS_FOR_HTML) {
            title <- paste("Download",
                           nrow(sv$subset),
                           "documents")
            if (highlight_terms_exist()) {
                title <- paste(title, "with highlighted text")
            }
        } else {
            title <- sprintf("Too many documents (max %s)", MAX_DOCS_FOR_HTML)
        }

        title

    })
})
