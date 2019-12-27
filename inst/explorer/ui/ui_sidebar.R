shinydashboard::dashboardSidebar(
    shinyWidgets::radioGroupButtons(
        inputId = "antall_linjer",
        label = "No. of terms to chart",
        choices = 1:6,
        justified = TRUE,
        size = "xs",
        selected = input_arguments_derived$number_of_search_terms
    ),

    shiny::tags$div(shiny::textInput("search_text_1", label = "Term(s) to chart and highlight",
                                     value = input_arguments$search_terms[1]),
             style = "margin-top: -1em;"),

    shiny::div(
    shiny::conditionalPanel(condition = "input.antall_linjer > 1",
                     shiny::textInput("search_text_2", label = NULL,
                                      value = input_arguments$search_terms[2])),
    shiny::conditionalPanel(condition = "input.antall_linjer > 2",
                     shiny::textInput("search_text_3", label = NULL,
                                      value = input_arguments$search_terms[3])),
    shiny::conditionalPanel(condition = "input.antall_linjer > 3",
                     shiny::textInput("search_text_4", label = NULL,
                                      value = input_arguments$search_terms[4])),
    shiny::conditionalPanel(condition = "input.antall_linjer > 4",
                     shiny::textInput("search_text_5", label = NULL,
                                      value = input_arguments$search_terms[5])),
    shiny::conditionalPanel(condition = "input.antall_linjer > 5",
                     shiny::textInput("search_text_6", label = NULL,
                                      value = input_arguments$search_terms[6])),
    class = "additional_search_terms"),

    shinyWidgets::checkboxGroupButtons(
        inputId = "more_terms_button",
        label = NULL,
        choices = list("Additional terms for text highlighting" = "Yes"),
        justified = TRUE,
        size = "sm",
        selected = input_arguments_derived$more_terms_button
    ),

    shiny::div(
    shiny::conditionalPanel(
        condition = "input.more_terms_button == 'Yes'",
        shiny::textAreaInput("highlight_terms_area", label = NULL, placeholder = "Terms separated by newline",
                             value = input_arguments_derived$highlight_terms)
    ), class = "more_terms_field"),

    shiny::hr(),

    shinyWidgets::checkboxGroupButtons(
        inputId = "subset_corpus",
        label = NULL,
        choices = list("Filter corpus?" = "Yes"),
        justified = TRUE,
        size = "sm",
        selected = input_arguments_derived$filter_corpus_button
    ),

    conditionalPanel(
        condition = "input.subset_corpus == 'Yes'",

        # Filter text area
        div(
            shiny::textAreaInput(
                "filter_text_area",
                label = NULL,
                placeholder = "Terms separated by newline",
                value = input_arguments_derived$filter_terms
            )
            ,
            class = "subset_field"
        ),

        # Conditionally rendered checkbox filtering UI in server
        shiny::uiOutput('checkbox_filtering_ui')
        ),

        # Conditionally rendered checkbox filtering UI in server
        shiny::uiOutput('magic_text_area_ui'),

    shiny::hr(),
    shinyWidgets::prettyCheckbox(inputId = "case_sensitivity",
                   label = "Case sensitive search (slower)",
                   value = input_arguments$case_sensitivity,
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
            min = 100,
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
        "search_button",
        label = "Search",
        size = "sm",
        style = "simple",
        block = TRUE
    )
)
