bslib::sidebar(
    # width = 220,
    open = TRUE,
    bg = "#ffffff",

    # Search terms with color legend
    shiny::div(
        class = "shiny-input-container w-100",
        style = "margin-bottom: 0.2rem;",
        shiny::tags$label("Search terms", class = "control-label"),
        shiny::div(class = "search-terms-legend", id = "search_terms_legend"),
        shiny::tags$textarea(
            id = "search_terms_area",
            class = "form-control",
            placeholder = "One term per line (max 6)",
            rows = 6,
            style = "font-size: 0.8rem; resize: vertical;",
            {
                terms <- input_arguments$search_terms[!is.na(input_arguments$search_terms) & input_arguments$search_terms != ""]
                if (length(terms) == 0) "" else paste(terms, collapse = "\n")
            }
        )
    ),

    # Options in accordion
    bslib::accordion(
        id = "sidebar_options",
        open = FALSE,
        multiple = TRUE,

        bslib::accordion_panel(
            title = "Highlight terms",
            value = "highlight",
            shiny::textAreaInput("highlight_terms_area", label = NULL,
                                placeholder = "One term per line", rows = 2,
                                value = input_arguments_derived$highlight_terms)
        ),

        bslib::accordion_panel(
            title = "Filter corpus",
            value = "filter",
            shiny::textAreaInput("filter_text_area", label = NULL,
                               placeholder = "One term per line", rows = 2,
                               value = input_arguments_derived$filter_terms),
            shiny::uiOutput('checkbox_filtering_ui')
        ),

        bslib::accordion_panel(
            title = "Date range",
            value = "daterange",
            shiny::uiOutput('time_filtering_ui')
        ),

        bslib::accordion_panel(
            title = "Plot size",
            value = "plotsize",
            shiny::sliderInput("PLOTSIZE", label = NULL, min = 100, ticks = FALSE,
                              step = 50, max = INITIAL_PLOT_SIZE * 2, value = INITIAL_PLOT_SIZE),
            shiny::actionButton("size_button", "Apply", class = "btn-sm btn-outline-secondary w-100")
        ),

        bslib::accordion_panel(
            title = "Layout",
            value = "layout",
            shiny::sliderInput("column_width", label = "Left column %", min = 30, max = 70,
                              value = CORPUS_MAP_COLUMN_WIDTH_PCT, step = 5, ticks = FALSE)
        )
    ),

    shiny::uiOutput('magic_text_area_ui'),

    # Case sensitivity as switch
    bslib::input_switch("case_sensitivity", "Case sensitive", value = input_arguments$case_sensitivity),

    # Plot mode - compact inline radio
    shiny::radioButtons("modus", label = "Plot mode",
                       choices = list("Calendar" = "data_365", "Wall" = "data_dok"),
                       selected = if (DATE_BASED_CORPUS == FALSE) "data_dok" else "data_365",
                       inline = TRUE),

    # Search button
    shiny::actionButton("search_button", "Search", class = "btn-primary w-100 mt-2")
)
