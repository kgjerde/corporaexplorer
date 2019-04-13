output$doc_list_tekst <- shiny::renderText({

    if (!("Title" %in% colnames(data_day))) {
        data_day$Title_2 <- seq_len(nrow(data_day))
    }


    c(
        "<b> Date: </b>",
        format_date(session_variables[[plot_mode$mode]]$Date[min_rad]), # TODO: fortsett duplisering: regner ut ukedag flere steder.
        "<br/>",
        "<b> Documents this day: </b>",
        nrow(data_day)
        ,
        rep("<br>", 2),
        paste(highlight_document(paste(data_day$Title_2, collapse = "<br>"),  # So it is passed as length 1
                                 unique(search_arguments$terms_highlight),
                                 MY_COLOURS,
                                 search_arguments$case_sensitive,
                                 '<span style="color:%s">\\1</span>'),
              "<br>")
    )
})
