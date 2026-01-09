shiny::observeEvent(input$search_button, {

# Reset navigation state --------------------------------------------------
reset_corpus_navigation()

# Updating session variables ----------------------------------------------
source("./server/2_event_search_button/update_session_variables.R", local = TRUE)

# UI element control ------------------------------------------------------
source("./server/2_event_search_button/UI_element_control.R", local = TRUE)

# Filtering corpus: time and terms ----------------------------------------
source("./server/2_event_search_button/subsetting.R", local = TRUE)

# Update navigation index for filtered data -------------------------------
update_navigable_days()

# Creating corpus map -----------------------------------------------------
source("./server/2_event_search_button/corpus_map_rendering.R", local = TRUE)

# Optional info to console (if so defined in constants.R) -----------------
if (OPTIONAL_INFO_TO_CONSOLE == TRUE) {
    source("./server/optional_info_to_console.R", local = TRUE)
}

})
