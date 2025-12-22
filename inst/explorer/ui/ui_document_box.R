shiny::div(
    bslib::navset_card_pill(
        id = "dokumentboks",
        full_screen = TRUE,
        # Empty placeholder - hidden, tabs added dynamically
        bslib::nav_panel(
            title = "",
            value = "placeholder"
        )
    ),
    class = "class_doc_box"
)
