shiny::observeEvent(input$plot_click, {

min_rad <-
        finn_min_rad(input$plot_click, session_variables$plot_build_info)



# Data 365 ----------------------------------------------------------------
    if (plot_mode$mode == "data_365") {
        if (length(min_rad) > 0) {
            if (session_variables[[plot_mode$mode]]$ID[min_rad] != 0) {


# UI element control ------------------------------------------------------
source("./server/3_event_corpus_map_click/UI_element_control_data_365.R", local = TRUE)

# Preparing the day's corpus ----------------------------------------------
source("./server/3_event_corpus_map_click/preparing_day_corpus.R", local = TRUE)

# List of document titles in tab ------------------------------------------
source("./server/3_event_corpus_map_click/title_list.R", local = TRUE)

# Corpus day map ----------------------------------------------------------
source("./server/3_event_corpus_map_click/rendering_day_corpus_map.R", local = TRUE)

                # Automatic scrolling of documents back to the top ------------------------
source("./server/3_event_corpus_map_click/js_auto_scrolling_to_top.R", local = TRUE)


            }
        }

# Data_dok ----------------------------------------------------------------

    } else if (plot_mode$mode == "data_dok") {
                if (length(min_rad) > 0) {

# UI element control ------------------------------------------------------
source("./server/3_event_corpus_map_click/UI_element_control_data_dok.R", local = TRUE)

# Text highlighting and text document display -----------------------------
source("./server/3_event_corpus_map_click/display_document_text.R", local = TRUE)

# Document info tab -------------------------------------------------------
source("./server/3_event_corpus_map_click/document_info_tab.R", local = TRUE)

# Document visualisation --------------------------------------------------
source("./server/3_event_corpus_map_click/document_visualisation.R", local = TRUE)


        }
    }
})



