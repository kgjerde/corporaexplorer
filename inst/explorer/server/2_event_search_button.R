shiny::observeEvent(input$search_button, {

# Updating session variables ----------------------------------------------
source("./server/2_event_search_button/update_session_variables.R", local = TRUE)

# UI element control ------------------------------------------------------
source("./server/2_event_search_button/UI_element_control.R", local = TRUE)

# Filtering corpus: time and terms ----------------------------------------
source("./server/2_event_search_button/subsetting.R", local = TRUE)

# Creating corpus map -----------------------------------------------------
source("./server/2_event_search_button/corpus_map_rendering.R", local = TRUE)

# Optional info to console (if so defined in constants.R) -----------------
if (OPTIONAL_INFO_TO_CONSOLE == TRUE) {
    source("./server/optional_info_to_console.R", local = TRUE)
}

})
