shiny::div(
    bslib::navset_card_tab(
        id = "day_corpus_box",
        full_screen = TRUE,
        title = "A day in the corpus",

        bslib::nav_panel(
            title = shiny::textOutput('title'),

            shiny::div(shiny::plotOutput(
                "dag_kart",
                click = "dag_klikk",
                hover = shiny::hoverOpts(id = "dag_hover"),
                dblclick = "dag_dobbeltklikk",
                height = "auto"
            ), class = "day_map")
        )
    ),
    class = "class_day_corpus"
)
