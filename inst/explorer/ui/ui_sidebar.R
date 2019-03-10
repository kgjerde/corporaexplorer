shinydashboard::dashboardSidebar(
    shinyWidgets::radioGroupButtons(
        inputId = "antall_linjer",
        label = "No. of terms to chart",
        choices = 1:4,
        justified = TRUE,
        size = "xs"
    ),
    
    shiny::tags$div(shiny::textInput("search_text", label = "Term(s) to chart"),
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
        choices = list("Add terms for text highlighting?" = "Yes"),
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
        # textInput("filter_text", label = NULL, placeholder = "Term to subset corpus")
    ), class = "subset_field"),
    
    shiny::hr(),

    shinyWidgets::prettyCheckbox(inputId = "case_sensitivity",
                   label = "Case sensitive search (slower)",
                   value = FALSE,
                   width = "100%",
                   icon = icon("check")),
    
    shiny::hr(),
        
    shinyWidgets::radioGroupButtons(
        inputId = "years_or_dates",
        label = NULL,
        choices = c("Year range", "Date range"),
        justified = TRUE,
        size = "sm"
    ),
    
    shiny::conditionalPanel(
        condition = "input.years_or_dates == 'Year range'",
        sliderInput(
            "date_slider",
            label = NULL,
            min = min(loaded_data$original_data$data_dok$Year),
            max = max(loaded_data$original_data$data_dok$Year),
            value = c(min, max),
            sep = ""
        )
    ),
    
    shiny::conditionalPanel(
        condition = "input.years_or_dates == 'Date range'",
        shiny::dateRangeInput(
            "date_calendar",
            label = NULL,
            weekstart = 1,
            start = min(loaded_data$original_data$data_dok$Date),
            end = max(loaded_data$original_data$data_dok$Date),
            min = min(loaded_data$original_data$data_dok$Date),
            max = max(loaded_data$original_data$data_dok$Date)
        )
        
    ),
    
    hr(),
    
    shinyWidgets::radioGroupButtons(
        inputId = "modus",
        label = "Plot mode",
        size = "sm",
        choices = list("Calendar" = "data_365", "Document wall" = "data_dok"),
        justified = TRUE
    ),
    
    shiny::hr(),
    
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
            step = 100,
            max = length(unique(loaded_data$original_data$data_365[["Year"]])) * 100,
            value = ceiling(length(unique(loaded_data$original_data$data_365[["Year"]])) * 7 * 10 + 15))
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
