# Convenience functions ---------------------------------------------------

#' Change class of UI element
#'
#' Used to show or hide element.
change_ui_class <- function(class_name, property, value) {
    shinyjs::runjs(sprintf(
        '$("%s").css({"%s":"%s"})',
        class_name,
        property,
        value
    ))
}


#' Show UI element
show_ui <- function(element_name_as_defined_in_ui_elements) {
    change_ui_class(ui_elements[[element_name_as_defined_in_ui_elements]],
                    property = "display",
                    value = "inline")
}

#' Hide UI element
hide_ui <- function(element_name_as_defined_in_ui_elements) {
    change_ui_class(ui_elements[[element_name_as_defined_in_ui_elements]],
                    property = "display",
                    value = "none")
}


#' Toggle ui element clickability function pair
make_clickable_ui <- function(class_name) {
    change_ui_class(class_name, "pointer-events", "auto")
}

make_unclickable_ui <- function(class_name) {
    change_ui_class(class_name, "pointer-events", "none")
}


# Document title for non-date-based corpora: UI ---------------------------
#' For box title and hover info
#'
doc_title_non_date_based_corpora <- function(min_rad) {
  title <- ""
  if (ONLY_ONE_GROUP_IN_NON_DATE_BASED_CORPUS == FALSE) {
    title <- paste0(title,
                        session_variables[[plot_mode$mode]]$Year_[min_rad],
                        " \u2013 ")
  }
  title <- paste0(title,
                      session_variables[[plot_mode$mode]]$cx_Seq[min_rad])
  return(title)
}

# Avoiding flashing sidebar elements on load (w/css) ----------------------
shiny::observeEvent(input$adjust_plotsize, {
    change_ui_class(".plotsize_field", property = "display", "inline")
})
shiny::observeEvent(input$subset_corpus, {
    change_ui_class(".subset_field", property = "display", "inline")
})
shiny::observeEvent(input$more_terms_button, {
    change_ui_class(".more_terms_field", property = "display", "inline")
})
shiny::observeEvent(input$antall_linjer, {
    change_ui_class(".additional_search_terms", property = "display", "inline")
})


# Corpus info tab: edit plot legend keys UI -------------------------------
observe({
  shinyjs::hide("edit_info_plot_legend_keys")
})


# Display plot mode in corpus map tab title -------------------------------

corpus_map_title <- function(plot_mode) {
    if (plot_mode == "data_365") {
        "Calendar view"
    } else if (plot_mode == "data_dok") {
        "Document wall view"
    }
}


# Add tabs ----------------------------------------------------------------

add_tab_doc_list_tekst <- function(dok_or_365) {
    shiny::appendTab(
        'dokumentboks',
        tab =
            bslib::nav_panel(
                title = shiny::textOutput('document_list_title'),
                value = "document_list_title",
                shiny::htmlOutput(
                    outputId = "doc_list_tekst",
                    container = shiny::tags$div,
                    class = paste0("boxed_doc_data_", dok_or_365)
                )
            ),

        select = TRUE,
        menuName = NULL,
        session = shiny::getDefaultReactiveDomain()
    )
}

add_tab_doc_tekst <- function(dok_or_365) {
    shiny::appendTab(
      'dokumentboks',
      tab =
          bslib::nav_panel(
              title = shiny::textOutput('document_box_title'),
              value = "document_box_title",
              shiny::plotOutput("dok_vis",
                         click = "dok_vis_click",
                         height = "auto"),

              shiny::htmlOutput(
                  outputId = "doc_tekst",
                  container = shiny::tags$div,
                  class = paste0("boxed_doc_data_", dok_or_365)
              )
          ),

      select = TRUE,
      menuName = NULL,
      session = shiny::getDefaultReactiveDomain()
  )
}

add_tab_doc_info <- function(dok_or_365) {
    shiny::appendTab(
        'dokumentboks',
        tab =
            bslib::nav_panel(
                title = shiny::textOutput('document_box_title_info'),
                value = "document_box_title_info",

                shiny::htmlOutput(
                    outputId = "doc_info",
                    container = shiny::tags$div,
                    class = paste0("boxed_doc_data_", dok_or_365)
                )

            ),

        select = FALSE,
        menuName = NULL,
        session = shiny::getDefaultReactiveDomain()
    )
}


# Remove tabs -------------------------------------------------------------

remove_tab_doc_list_tekst <- function() {
    shiny::removeTab('dokumentboks',
              target = "document_list_title",
              session = shiny::getDefaultReactiveDomain())
}

remove_tab_doc_tekst <- function() {
    shiny::removeTab('dokumentboks',
            target = "document_box_title",
            session = shiny::getDefaultReactiveDomain())
}

remove_tab_doc_info <- function() {
    shiny::removeTab('dokumentboks',
              target = "document_box_title_info",
              session = shiny::getDefaultReactiveDomain())
}

