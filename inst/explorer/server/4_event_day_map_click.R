shiny::observeEvent(input$dag_klikk, {
    # Auto-scrolling to the top when new document clicked
    shinyjs::runjs("$('.class_doc_box .doc-content-searchable').scrollTo('0%');")

    min_rad <-
        finn_min_rad(input$dag_klikk, session_variables$plotinfo_dag)

if (length(min_rad) > 0) {
# UI element control ------------------------------------------------------
source("server/4_event_day_map_click/UI_element_control_data.R", local = TRUE)

# Document info tab -------------------------------------------------------
source("server/4_event_day_map_click/document_info_tab_data_365.R", local = TRUE)

# Document text (and visualisation) tab -----------------------------------
source("server/4_event_day_map_click/document_text_vis_tab.R", local = TRUE)

# Potential "extra" tab ---------------------------------------------------
if (INCLUDE_EXTRA == TRUE) {
    create_extra_tab_content(plot_mode$mode, min_rad)
}

}
})
