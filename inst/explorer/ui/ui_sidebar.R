shinydashboard::dashboardSidebar(
    shinyWidgets::radioGroupButtons(
        inputId = "antall_linjer",
        label = "No. of terms to chart",
        choices = 1:2,
        justified = TRUE,
        width = '160px',
        size = "xs"
    ),

    shiny::tags$div(shiny::textInput("search_text", label = "Term(s) to chart and highlight"),
             style = "margin-top: -1em;"),

    shiny::div(
    shiny::conditionalPanel(condition = "input.antall_linjer > 1",
                     shiny::textInput("area_2", label = NULL)),
    shiny::conditionalPanel(condition = "input.antall_linjer > 2",
                     shiny::textInput("area_3", label = NULL)),
    shiny::conditionalPanel(condition = "input.antall_linjer > 3",
                     shiny::textInput("area_4", label = NULL)),
    shiny::conditionalPanel(condition = "input.antall_linjer > 4",
                     shiny::textInput("area_5", label = NULL)),
    shiny::conditionalPanel(condition = "input.antall_linjer > 5",
                     shiny::textInput("area_6", label = NULL)),
    class = "additional_search_terms"),

    shinyWidgets::checkboxGroupButtons(
        inputId = "more_terms_button",
        label = NULL,
        choices = list("Additional terms for text highlighting" = "Yes"),
        justified = TRUE,
        size = "sm"
    ),

    shiny::div(
    shiny::conditionalPanel(
        condition = "input.more_terms_button == 'Yes'",
        shiny::textAreaInput("area", label = NULL, placeholder = "Terms separated by newline")
    ), class = "more_terms_field"),

    shiny::hr(),

    shinyWidgets::checkboxGroupButtons(
        inputId = "subset_corpus",
        label = NULL,
        choices = list("Filter corpus?" = "Yes"),
        justified = TRUE,
        size = "sm"
    ),
    div(
    conditionalPanel(
        condition = "input.subset_corpus == 'Yes'",
        textAreaInput("filter_text", label = NULL, placeholder = "Terms separated by newline")
    ), class = "subset_field"),

    shiny::hr(),

    shinyWidgets::prettyCheckbox(inputId = "case_sensitivity",
                   label = "Case sensitive search (slower)",
                   value = FALSE,
                   width = "100%",
                   icon = icon("check")),

    shiny::hr(),

    # Conditionally rendered time filtering UI in server
    shiny::uiOutput('time_filtering_ui'),

    shinyWidgets::radioGroupButtons(
        inputId = "modus",
        label = "Plot mode",
        size = "sm",
        choices = list("Calendar" = "data_365", "Document wall" = "data_dok"),
        selected = if (DATE_BASED_CORPUS == FALSE) "data_dok" else "data_365",
        justified = TRUE
    ),

    shiny::hr(class = "conditional_hr"),

    shinyWidgets::checkboxGroupButtons(
        inputId = "adjust_plotsize",
        label = NULL,
        choices = list("Adjust plot size?" = "Yes"),
        justified = TRUE,
        size = "sm"
    ),

     shiny::div(shiny::conditionalPanel(
           condition = "input.adjust_plotsize == 'Yes'",
        shiny::sliderInput(
            inputId = "PLOTSIZE",
            label = NULL,
            min = 150,
            ticks = FALSE,
            step = 50,
            max = plot_size(loaded_data$original_data$data_dok,
                            DATE_BASED_CORPUS) * 2,
            value = plot_size(loaded_data$original_data$data_dok,
                              DATE_BASED_CORPUS)
            )
        ), class = "plotsize_field"
    ),

    shiny::hr(),

    shinyWidgets::actionBttn(
        "trykk",
        label = "Search",
        size = "sm",
        style = "simple",
        block = TRUE
    )
)
