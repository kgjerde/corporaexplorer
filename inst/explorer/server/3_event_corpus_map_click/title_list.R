output$doc_list_tekst <- shiny::renderText({
    c(
        "<b> Date: </b>",
        as.character(format(session_variables[[plot_mode$mode]]$Date[min_rad],
                        "%A %d %B %Y")), # TODO: fortsett duplisering: regner ut ukedag flere steder.
        "<br/>",
        "<b> Documents this day: </b>",
        nrow(data_day)
        ,
        rep("<br>", 2),
        paste(highlight_document(data_day$Title_2,
                                 unique(search_arguments$terms_highlight),
                                 MY_COLOURS,
                                 search_arguments$case_sensitive,
                                 '<span style="color:%s">\\1</span>'),
              "<br>")
    )
})
