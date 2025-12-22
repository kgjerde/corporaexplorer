shiny::div(
    bslib::card(
        id = "day_corpus_box",
        full_screen = TRUE,

        bslib::card_header(
            shiny::span("A day in the corpus", class = "fw-semibold me-2", style = "font-size: 0.75rem;"),
            shiny::textOutput('title', inline = TRUE)
        ),

        bslib::card_body(
            shiny::div(
                shiny::plotOutput(
                    "dag_kart",
                    click = "dag_klikk",
                    hover = shiny::hoverOpts(id = "dag_hover"),
                    dblclick = "dag_dobbeltklikk",
                    height = "90px"
                ),
                class = "day_map"
            )
        )
    ),
    class = "class_day_corpus"
)
