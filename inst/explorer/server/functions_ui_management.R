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
