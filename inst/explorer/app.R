
# Setting up data and config ----------------------------------------------
if (!is.null(getOption("shiny.testmode"))) {
  if (getOption("shiny.testmode") == TRUE) {
    source("./config/config_tests.R", local = TRUE)
  }
} else {
  source("./config/config.R", local = TRUE)
}

# Function files ----------------------------------------------------------
source("./global/function_display_document.R", local = TRUE)
source("./global/function_display_document_info.R", local = TRUE)
source("./global/function_filter_corpus.R", local = TRUE)
source("./global/function_find_row_in_df.R", local = TRUE)
source("./global/function_format_date.R", local = TRUE)
source("./global/function_insert_doc_links.R", local = TRUE)
source("./global/function_plot_size.R", local = TRUE)
source("./global/function_visualise_corpus.R", local = TRUE)
source("./global/function_visualise_document.R", local = TRUE)
source("./global/functions_info.R", local = TRUE)
source("./global/functions_main_search_engine.R", local = TRUE)

#=============================================================================#
####================================  UI  =================================####
#=============================================================================#

ui <- function(request) {
  shinydashboard::dashboardPage(
    title = 'Corpus exploration',

    # Header --------------------------------------------------------------
    source("./ui/ui_header.R", local = TRUE)$value,

    # Sidebar -------------------------------------------------------------
    source("./ui/ui_sidebar.R", local = TRUE)$value,

    # Body ----------------------------------------------------------------

    shinydashboard::dashboardBody(
      # CSS and JS files --------------------------------------------------
      source("./ui/css_js_import.R", local = TRUE)$value,
      source("./ui/css_from_arguments.R", local = TRUE)$value,

      # Fluid row ---------------------------------------------------------

      shiny::fluidRow(
               # Corpus map/corpus info box -------------------------------
               source("./ui/ui_corpus_box.R", local = TRUE)$value,

               # A day in the corpus box (for data_365) -------------------
               source("./ui/ui_day_in_corpus_box.R", local = TRUE)$value,

               # Document box ---------------------------------------------
               source("./ui/ui_document_box.R", local = TRUE)$value

               # Fluid row ends
               )

               # shinyjs
               ,
               shinyjs::useShinyjs()
               # Body ends
      )
      # Page ends
    )
}

#=============================================================================#
####================================SERVER=================================####
#=============================================================================#

server <- function(input, output, session) {

# Conditional sidebar UI elements -----------------------------------------
source("./ui/render_ui_sidebar_date_filtering.R", local = TRUE)
source("./ui/hide_ui_sidebar_plot_mode.R", local = TRUE)

# Session variables -------------------------------------------------------
source("./server/session_variables.R", local = TRUE)

# Session scope function files --------------------------------------------
source("./server/functions_collect_input_terms.R", local = TRUE)
source("./server/functions_checking_input_terms.R", local = TRUE)
source("./server/functions_ui_management.R", local = TRUE)
source("./server/function_collect_edited_info_plot_legend_keys.R", local = TRUE)

# Corpus info tab ---------------------------------------------------------
source("./server/corpus_info_tab.R", local = TRUE)

# 1. Startup actions ------------------------------------------------------
source("./server/1_startup_actions.R", local = TRUE)

# 2. Event: search button -------------------------------------------------
source("./server/2_event_search_button.R", local = TRUE)

# 3. Event: click in corpus map -------------------------------------------
source("./server/3_event_corpus_map_click.R", local = TRUE)

# 4. Event: click in day map ----------------------------------------------
source("./server/4_event_day_map_click.R", local = TRUE)

# 5. Event: click in document visualisation -------------------------------
source("./server/5_event_document_visualisation_click.R", local = TRUE)

# 6. Event: hovering in corpus map ----------------------------------------
source("./server/6_event_hover_corpus_map.R", local = TRUE)

# Cleaning up the session -------------------------------------------------
shiny::onSessionEnded(function() {
  shiny::shinyOptions("corporaexplorer_use_matrix" = NULL)
  shiny::shinyOptions("corporaexplorer_regex_engine" = NULL)
  shiny::shinyOptions("corporaexplorer_data" = NULL)
  shiny::shinyOptions("corporaexplorer_optional_info" = NULL)
  shiny::shinyOptions("corporaexplorer_allow_unreasonable_patterns" = NULL)
  shiny::shinyOptions("corporaexplorer_ui_options" = NULL)
  shiny::shinyOptions("corporaexplorer_input_arguments" = NULL)
})
}

# Run app -----------------------------------------------------------------
shiny::shinyApp(ui, server)
