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
    
    shinyWidgets::checkboxGroupButtons(
        inputId = "subset_corpus",
        label = NULL,
        choices = list("Filter corpus?" = "Yes"),
        justified = TRUE,
        size = "sm"
    ),
    shiny::conditionalPanel(
        condition = "input.subset_corpus != 'Yes'",
        textAreaInput("filter_text", label = NULL, placeholder = "Terms separated by newline")
        # textInput("filter_text", label = NULL, placeholder = "Term to subset corpus")
    ),
    
    hr(),
    
    shinyWidgets::prettyCheckbox(
        inputId = "case_sensitivity",
        label = "Case sensitive search",
        value = FALSE,
        width = "100%",
        icon = icon("check")
    ),
    
    shiny::hr(), 
    
    
    shinyWidgets::radioGroupButtons(
        inputId = "year_or_date",
        label = NULL,
        choices = c("Year range", "Date range"),
        justified = TRUE,
        size = "sm"
    ),
    
    shiny::conditionalPanel(
        condition = "input.year_or_date == 'Year range'",
        sliderInput(
            "date_slider",
            label = NULL,
            min = min(abc$Year),
            max = max(abc$Year),
            value = c(min, max),
            sep = ""
        )
    ),
    
    shiny::conditionalPanel(
        condition = "input.year_or_date == 'Date range'",
        shiny::dateRangeInput(
            "date_calendar",
            label = NULL,
            weekstart = 1,
            start = min(abc$Date),
            end = max(abc$Date),
            min = min(abc$Date),
            max = max(abc$Date)
        )
        
    ),
    
    hr(),
    
    shinyWidgets::actionBttn(
        "trykk",
        label = "Search",
        size = "sm",
        style = "simple",
        block = TRUE
    )
)
