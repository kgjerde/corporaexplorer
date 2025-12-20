bslib::navset_card_tab(
    id = "corpus_box",
    full_screen = TRUE,
    title = CORPUS_TITLE,

    bslib::nav_panel(
        title = shiny::textOutput('korpuskarttittel'),
        value = "korpuskart_tab",

        shiny::div("Preparing corpus map", class = "progress_text"),

        shiny::div(
            style = "position:relative",
            shiny::plotOutput(
                "korpuskart",
                click = "plot_click",
                hover = shiny::hoverOpts(
                    id = "plot_hover",
                    delayType = "debounce",
                    delay = 500
                ),
                dblclick = "dobbeltklikk",
                height = "auto",
                width = "100%"
            )
            ,
            shiny::uiOutput("hover_info")
        )

    ),

    bslib::nav_panel(
        title = "Corpus info",
        shiny::htmlOutput("corpus_info"),
        shiny::htmlOutput("search_results"),
        shiny::div(style = 'overflow-x: scroll', shiny::tableOutput('TABLE')),
        shiny::htmlOutput("info_plot_title"),
        shiny::plotOutput("corpus_info_plot", width = "100%", height = "250px"),
        shiny::br(),

# Edit plot legend keys UI ------------------------------------------------

        shinyWidgets::checkboxGroupButtons(
            inputId = "edit_info_plot_legend_keys",
            label = NULL,
            choices = list("Edit plot legend?" = "Yes"),
            justified = TRUE,
            size = "xs"
        ),

        shiny::conditionalPanel(
            condition = "input.edit_info_plot_legend_keys == 'Yes'",
            shiny::br(),

            shiny::flowLayout(
                shiny::uiOutput("column_info_names_ui"),
                shiny::div(
                    "Edit to change the legend key associated with a colour in the plot.",
                    class = "text_in_box"
                )
            ),

            shinyWidgets::actionBttn(
                "update_info_plot_legend_keys",
                label = "Update legend",
                size = "xs",
                style = "simple",
                block = FALSE
            )
        )
    )
)
