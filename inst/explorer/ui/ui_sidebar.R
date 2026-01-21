bslib::sidebar(
  open = TRUE,
  bg = "#ffffff",

  bslib::accordion(
    id = "sidebar_options",
    open = c("search", "plotmode"),
    multiple = TRUE,

    bslib::accordion_panel(
      title = "Term(s) to chart and highlight",
      value = "search",
      shiny::div(
        class = "search-terms-legend",
        id = "search_terms_legend"
      ),
      shiny::tags$textarea(
        id = "search_terms_area",
        class = "form-control",
        placeholder = "Terms separated by newline (max 6)",
        rows = 6,
        style = "font-size: 0.8rem; resize: vertical;",
        {
          terms <- input_arguments$search_terms[
            !is.na(input_arguments$search_terms) &
              input_arguments$search_terms != ""
          ]
          if (length(terms) == 0) {
            ""
          } else {
            paste(terms, collapse = "\n")
          }
        }
      )
    ),

    bslib::accordion_panel(
      title = "Highlight additional terms",
      value = "highlight",
      shiny::div(
        class = "search-terms-legend",
        id = "highlight_terms_legend"
      ),
      shiny::textAreaInput(
        "highlight_terms_area",
        label = NULL,
        placeholder = "Terms separated by newline",
        rows = 2,
        value = input_arguments_derived$highlight_terms
      )
    ),

    bslib::accordion_panel(
      title = "Filter corpus",
      value = "filter",
      shiny::checkboxInput(
        "filter_by_search_terms",
        label = "Add search terms to filters",
        value = FALSE
      ),
      shiny::uiOutput("filter_by_search_terms_preview"),
      shiny::textAreaInput(
        "filter_text_area",
        label = NULL,
        placeholder = "Terms separated by newline",
        rows = 2,
        value = input_arguments_derived$filter_terms
      ),
      shiny::uiOutput('checkbox_filtering_ui')
    ),

    if (DATE_BASED_CORPUS) {
      bslib::accordion_panel(
        title = "Date range",
        value = "daterange",
        shiny::uiOutput('time_filtering_ui')
      )
    },

    bslib::accordion_panel(
      title = "Search options",
      value = "search_options",
      bslib::input_switch(
        "case_sensitivity",
        "Case sensitive (slower)",
        value = input_arguments$case_sensitivity
      )
    ),

    bslib::accordion_panel(
      title = "Layout",
      value = "layout",
      shiny::div(
        class = "d-flex align-items-center gap-2",
        shiny::div(
          style = "flex: 1; min-width: 0;",
          shiny::sliderInput(
            "PLOTSIZE",
            label = "Corpus map height",
            min = 100,
            ticks = FALSE,
            step = 50,
            max = INITIAL_PLOT_SIZE * 2,
            value = INITIAL_PLOT_SIZE
          )
        ),
        shiny::actionButton(
          "size_button",
          "Apply",
          class = "btn-sm btn-outline-secondary py-0 px-2",
          style = "font-size: 0.7rem; margin-top: 0.5rem;"
        )
      ),
      shiny::div(
        style = "margin-top: 0.5rem;",
        shiny::sliderInput(
          "column_width",
          label = "Left column %",
          min = 30,
          max = 70,
          value = CORPUS_MAP_COLUMN_WIDTH_PCT,
          step = 5,
          ticks = FALSE
        )
      )
    ),

    if (DATE_BASED_CORPUS) {
      bslib::accordion_panel(
        title = "Plot mode",
        value = "plotmode",
        shiny::radioButtons(
          "modus",
          label = NULL,
          choices = list(
            "Calendar" = "data_365",
            "Document wall" = "data_dok"
          ),
          selected = "data_365",
          inline = TRUE
        )
      )
    }
  ),

  if (INCLUDE_EXTRA) shiny::uiOutput('magic_text_area_ui'),

  # Search button
  shiny::actionButton(
    "search_button",
    "Search",
    class = "btn-primary w-100 mt-2"
  )
)
