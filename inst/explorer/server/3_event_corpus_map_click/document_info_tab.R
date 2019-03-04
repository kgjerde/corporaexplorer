# Doc-info-fane TODO: write function avoid repetition.
output$doc_info <- shiny::renderText({
    doc_info_text <- paste(sep = "<br>",
                           paste0(
                               tags$b("Date: "),
                               format(session_variables$data_dok$Date[min_rad],
                                      "%A %d %B %Y")
                           ))
    
    if ("Title" %in% INFO_COLUMNS) {
        doc_info_text <- paste(sep = "<br>",
                               doc_info_text,
                               paste0(tags$b("Title: "),
                                      session_variables$data_dok$Title[min_rad]))
    }
    
    if ("URL" %in% INFO_COLUMNS) {
        doc_info_text <- paste(
            sep = "<br>",
            doc_info_text,
            paste0(
                tags$b("URL: "),
                "<a href='",
                session_variables$data_dok$URL[min_rad],
                "'a <- tb target='_blank'>",
                session_variables$data_dok$URL[min_rad],
                "</a>"
            )
        )
    }
    
    other_columns <- INFO_COLUMNS[!INFO_COLUMNS %in% c("Date", "Title", "URL")]
    
    for (i in seq_along(other_columns)) {
        doc_info_text <- paste(doc_info_text,
                               sep = "<br>",
                               paste0(
                                   tags$b(other_columns[i]),
                                   tags$b(": "),
                                   session_variables$data_dok[[other_columns[i]]][min_rad]
                               ))
    }
    
    doc_info_text <- paste(doc_info_text,
                           sep = "<br>",
                           paste0(
                               tags$b("Word count: "),
                               stringi::stri_count_words(session_variables$data_dok$Text[min_rad])
                           ))
    
    doc_info_text
})
