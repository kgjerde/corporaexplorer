
# Setting up data and config ----------------------------------------------
source("./global/config.R", local = TRUE)

# Function files ----------------------------------------------------------
source("./global/function_display_document.R", local = TRUE)
source("./global/function_filter_corpus.R", local = TRUE)
source("./global/function_find_row_in_df.R", local = TRUE)
source("./global/function_insert_doc_links.R", local = TRUE)
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

    # Header ------------------------------------------------------------------
    source("./ui/ui_header.R", local = TRUE)$value,

    # Sidebar -----------------------------------------------------------------
    source("./ui/ui_sidebar.R", local = TRUE)$value,

    # Body --------------------------------------------------------------------

    shinydashboard::dashboardBody(
      # CSS and JS files --------------------------------------------------------
      source("./ui/css_js_import.R", local = TRUE)$value,

      # Fluid row ---------------------------------------------------------------

      shiny::fluidRow(
               # Corpus map/corpus info box ----------------------------------------------
               source("./ui/ui_corpus_box.R", local = TRUE)$value,

               # A day in the corpus box (for data_365) ----------------------------------
               source("./ui/ui_day_in_corpus_box.R", local = TRUE)$value,

               # Document box ------------------------------------------------------------
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

# Session variables -------------------------------------------------------
source("./server/session_variables.R", local = TRUE)

# Server scope function files ----------------------------------------------------------
source("./server/functions_collect_input_terms.R", local = TRUE)
source("./server/functions_checking_input_terms.R", local = TRUE)
source("./server/functions_ui_management.R", local = TRUE)

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

  shiny::onSessionEnded(function() shiny::shinyOptions(ost = NULL))
}

# Run the application
shiny::shinyApp(ui, server)
