# CSS from function arguments ---------------------------------------------

# Font size

if (!is.null(ui_options$font_size)) {
    shinyjs::inlineCSS(
        sprintf(
            ".boxed_doc_data_365, .boxed_doc_data_dok {font-size: %s;}",
            ui_options$font_size
        )
    )
}
