bslib::navset_card_pill(
    id = "corpus_box",
    full_screen = TRUE,

    bslib::nav_panel(
        title = shiny::textOutput('korpuskarttittel'),
        value = "korpuskart_tab",

        shiny::plotOutput(
            "korpuskart",
            click = "plot_click",
            hover = shiny::hoverOpts(
                id = "plot_hover",
                delayType = "debounce",
                delay = 500
            ),
            dblclick = "dobbeltklikk",
            height = "calc(100vh - 140px)",
            width = "100%"
        )
    ),

    bslib::nav_panel(
        title = "Corpus info",
        shiny::htmlOutput("corpus_info"),
        shiny::htmlOutput("search_results"),
        shiny::div(style = 'overflow-x: auto', shiny::tableOutput('TABLE')),
        shiny::htmlOutput("info_plot_title"),
        shiny::plotOutput("corpus_info_plot", width = "100%", height = "250px"),

        shiny::checkboxInput(
            inputId = "edit_info_plot_legend_keys",
            label = "Edit plot legend?",
            value = FALSE
        ),

        shiny::conditionalPanel(
            condition = "input.edit_info_plot_legend_keys == true",
            shiny::uiOutput("column_info_names_ui"),
            shiny::actionButton(
                "update_info_plot_legend_keys",
                label = "Update legend",
                class = "btn-sm btn-outline-secondary mt-2"
            )
        )
    )
)
