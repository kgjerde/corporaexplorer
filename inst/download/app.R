
# Data set-up -------------------------------------------------------------
if (!is.null(getOption("shiny.testmode"))) {
  if (getOption("shiny.testmode") == TRUE) {
    library(corpusexplorationr)
    abc <- test_data
  }
} else {
  abc <- eval(as.name(shiny::getShinyOption("corpusexplorationr_download_data")))
}

if (class(abc) == "corpusexplorationobject") {
  abc <- abc$original_data$data_dok
  abc$Text <- abc$Text_case
}

# Loading constants -------------------------------------------------------
source("./global/config.R", local = TRUE)

# **UI** ------------------------------------------------------------------

ui <- function(request) {
  shinydashboard::dashboardPage(
    skin = "purple",
    title = "Document download tool",


    # Header ------------------------------------------------------------------
    shinydashboard::dashboardHeader(
      title = 'Document download\ntool',
      titleWidth = 275,
      shinydashboard::dropdownMenuOutput("dropdownmenu")
    ),

    # Sidebar -----------------------------------------------------------------
    source("./ui/ui_sidebar.R", local = TRUE)$value,

    # Body --------------------------------------------------------------------
    shinydashboard::dashboardBody(

    # CSS and JS files --------------------------------------------------------
    source("./ui/css_js_import.R", local = TRUE)$value,

    # Fluid row ---------------------------------------------------------------
    shiny::fluidRow(
      shiny::column(width = 6,

     # Info box ----------------------------------------------------------------
     source("./ui/ui_info_box.R", local = TRUE)$value,
     # Download box ------------------------------------------------------------
     source("./ui/ui_download_box.R", local = TRUE)$value)
                  ),
    shinyjs::useShinyjs())
  )
}

# **SERVER** --------------------------------------------------------------

server <- function(input, output, session) {

# Loading functions -------------------------------------------------------
source("server/functions_term_collection.R", local = TRUE)
source("server/function_subset.R", local = TRUE)
source("server/function_corpus_info.R", local = TRUE)
source("server/function_subset_arguments.R", local = TRUE)

# Session variables -------------------------------------------------------
source("./server/session_variabler.R", local = TRUE)

# Element control ---------------------------------------------------------
source("./server/server_element_control.R", local = TRUE)

# Info on start-up --------------------------------------------------------
source("./server/server_info_on_startup.R", local = TRUE)

# Event: search button ----------------------------------------------------
source("./server/server_event_search_button.R", local = TRUE)

# Txt ---------------------------------------------------------------------
source("./server/server_download_txt.R", local = TRUE)

# Zip ---------------------------------------------------------------------
source("./server/server_download_zip.R", local = TRUE)

# HTML --------------------------------------------------------------------
source("./server/server_download_html.R", local = TRUE)

# Cleaning up the session -------------------------------------------------
shiny::onSessionEnded(function() {
  shiny::shinyOptions("corpusexplorationr_download_data" = NULL)
  shiny::shinyOptions("corpusexplorationr_download_max_html" = NULL)
})
}

# Run app -----------------------------------------------------------------

shiny::shinyApp(ui, server)
