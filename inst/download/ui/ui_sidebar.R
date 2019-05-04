shinydashboard::dashboardSidebar(
    width = 275,
    shinyWidgets::radioGroupButtons(
        inputId = "antall_linjer",
        label = "No. of terms to highlight",
        choices = 1:6,
        justified = TRUE,
        size = "xs"
    ),

    tags$div(textInput("search_text", label = "Term(s) to highlight"),
             style = "margin-top: -1em;"),

    shiny::conditionalPanel(condition = "input.antall_linjer > 1",
                     textInput("area_2", label = NULL)),
    shiny::conditionalPanel(condition = "input.antall_linjer > 2",
                     textInput("area_3", label = NULL)),
    shiny::conditionalPanel(condition = "input.antall_linjer > 3",
                     textInput("area_4", label = NULL)),
    shiny::conditionalPanel(condition = "input.antall_linjer > 4",
                     textInput("area_5", label = NULL)),
    shiny::conditionalPanel(condition = "input.antall_linjer > 5",
                     textInput("area_6", label = NULL)),

    shinyWidgets::checkboxGroupButtons(
        inputId = "more_terms_button",
        label = NULL,
        choices = list("Highlight even more terms?" = "Yes"),
        justified = TRUE,
        size = "sm"
    ),

    shiny::conditionalPanel(
        condition = "input.more_terms_button == 'Yes'",
        textAreaInput("area", label = NULL, placeholder = "Terms separated by newline")
    ),

    hr(),

        textAreaInput("filter_text",
                      label = "Filter corpus?",
                      placeholder = "Terms separated by newline"),

    hr(),

    shinyWidgets::prettyCheckbox(
        inputId = "case_sensitivity",
        label = "Case sensitive search",
        value = FALSE,
        width = "100%",
        icon = icon("check")
    ),

    shiny::hr(),

    shiny::uiOutput('time_filtering_ui'),

    shinyWidgets::actionBttn(
        "trykk",
        label = "Search",
        size = "sm",
        style = "simple",
        block = TRUE
    )
)
