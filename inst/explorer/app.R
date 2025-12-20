
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

# Setting up data and config ----------------------------------------------
if (!is.null(getOption("shiny.testmode"))) {
  if (getOption("shiny.testmode") == TRUE) {
    source("./config/config_tests.R", local = TRUE)
  }
} else {
  source("./config/config.R", local = TRUE)
}

#=============================================================================#
####================================  UI  =================================####
#=============================================================================#

ui <- function(request) {
  bslib::page_sidebar(
    title = if (CORPUS_TITLE == "Corpus map") "Corpus exploration" else CORPUS_TITLE,
    theme = bslib::bs_theme(version = 5),
    fillable = TRUE,

    # Sidebar -------------------------------------------------------------
    sidebar = source("./ui/ui_sidebar.R", local = TRUE)$value,

    # CSS and JS files ----------------------------------------------------
    source("./ui/css_js_import.R", local = TRUE)$value,
    source("./ui/css_from_arguments.R", local = TRUE)$value,

    # Main content --------------------------------------------------------
    bslib::layout_columns(
      col_widths = c(6, 6),
      fill = TRUE,
      fillable = TRUE,

      # Left column: Corpus map/corpus info box
      source("./ui/ui_corpus_box.R", local = TRUE)$value,

      # Right column: Day corpus box + Document box stacked
      bslib::layout_columns(
        col_widths = 12,
        fill = TRUE,
        fillable = TRUE,

        # A day in the corpus box (for data_365)
        source("./ui/ui_day_in_corpus_box.R", local = TRUE)$value,

        # Document box
        source("./ui/ui_document_box.R", local = TRUE)$value
      )
    ),

    # shinyjs
    shinyjs::useShinyjs(),
    shinyWidgets::useSweetAlert()
  )
}

#=============================================================================#
####================================SERVER=================================####
#=============================================================================#

server <- function(input, output, session) {

# Session scope function files --------------------------------------------
source("./server/functions_collect_input_terms.R", local = TRUE)
source("./server/functions_checking_input.R", local = TRUE)
source("./server/functions_ui_management.R", local = TRUE)
source("./server/function_collect_edited_info_plot_legend_keys.R", local = TRUE)

# Conditional and customised sidebar UI elements --------------------------
source("./ui/render_ui_sidebar_checkbox_filtering.R", local = TRUE)
source("./ui/render_ui_sidebar_date_filtering.R", local = TRUE)
source("./ui/hide_ui_sidebar_plot_mode.R", local = TRUE)
source("./ui/set_colours_in_search_fields.R", local = TRUE)

# Session variables -------------------------------------------------------
source("./server/session_variables.R", local = TRUE)

# For use with potential "extra" plugins ----------------------------------
if (INCLUDE_EXTRA == TRUE) {
  source("./extra/extra_render_ui_sidebar_magic_filtering.R", local = TRUE)
  source("./extra/extra_tab_content.R", local = TRUE)
  source("./extra/extra_ui_management_functions.R", local = TRUE)
  source("./extra/extra_session_variables.R", local = TRUE)
}

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

# 7. Event: update plot size ----------------------------------------------
source("./server/7_event_plot_size_button.R", local = TRUE)

# Cleaning up the session -------------------------------------------------
shiny::onSessionEnded(function() {
  shiny::shinyOptions("corporaexplorer_data" = NULL)
  shiny::shinyOptions("corporaexplorer_search_options" = NULL)
  shiny::shinyOptions("corporaexplorer_ui_options" = NULL)
  shiny::shinyOptions("corporaexplorer_input_arguments" = NULL)
  shiny::shinyOptions("corporaexplorer_plot_options" = NULL)
  shiny::shinyOptions("corporaexplorer_extra" = NULL)
})
}

# Run app -----------------------------------------------------------------
shiny::shinyApp(ui, server)
