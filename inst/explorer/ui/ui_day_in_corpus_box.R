shiny::div(shinydashboard::tabBox(
    width = 6,
    title = "A day in the corpus",
    shiny::tabPanel(
        title = shiny::textOutput('title'),
        #"Dokumentvisning",

        div(shiny::plotOutput(
            "dag_kart",
            click = "dag_klikk",
            hover = shiny::hoverOpts(id = "dag_hover"),
            dblclick = "dag_dobbeltklikk",
            height = "auto"
        ), class = "day_map")
    )
),
class = "class_day_corpus")
