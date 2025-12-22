shiny::div(
    bslib::navset_card_tab(
        id = "dokumentboks",
        full_screen = TRUE,
        # Empty placeholder - tabs added dynamically
        bslib::nav_panel(
            title = "Document",
            value = "placeholder",
            shiny::div(
                class = "text-muted p-3",
                "Click on the corpus map to view a document."
            )
        )
    ),
    class = "class_doc_box"
)
