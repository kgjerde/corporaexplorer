shiny::div(
  bslib::card(
    id = "day_corpus_box",
    full_screen = TRUE,

    bslib::card_header(
      class = "d-flex justify-content-between align-items-center",
      shiny::div(
        shiny::span(
          "A day in the corpus",
          class = "fw-semibold me-2",
          style = "font-size: 0.75rem;"
        ),
        shiny::textOutput('title', inline = TRUE)
      ),
      # Navigation arrows
      shiny::div(
        class = "nav-arrows",
        shiny::actionLink(
          "nav_prev_day",
          label = NULL,
          icon = shiny::icon("chevron-left"),
          class = "text-secondary px-1"
        ),
        shiny::span(
          id = "nav_pos_day",
          class = "nav-position text-muted"
        ),
        shiny::actionLink(
          "nav_next_day",
          label = NULL,
          icon = shiny::icon("chevron-right"),
          class = "text-secondary px-1"
        )
      )
    ),

    bslib::card_body(
      shiny::div(
        shiny::plotOutput(
          "dag_kart",
          click = "dag_klikk",
          hover = shiny::hoverOpts(id = "dag_hover"),
          dblclick = "dag_dobbeltklikk",
          height = "auto"
        ),
        class = "day_map"
      )
    )
  ),
  class = "class_day_corpus"
)
