# Convenience functions ---------------------------------------------------

#' Change class of UI element
#' 
#' Used to show or hide element.
change_ui_class <- function(class_name, display_property) {
    shinyjs::runjs(sprintf(
        '$("%s").css({"display":"%s"})',
        class_name,
        display_property
    ))
}


#' Show UI element
show_ui <- function(element_name_as_defined_in_ui_elements) {
    change_ui_class(ui_elements[[element_name_as_defined_in_ui_elements]], "inline")
}

#' Hide UI element
hide_ui <- function(element_name_as_defined_in_ui_elements) {
    change_ui_class(ui_elements[[element_name_as_defined_in_ui_elements]], "none")
}


# Avoiding flashing sidebar elements on load (w/css) ----------------------
shiny::observeEvent(input$adjust_plotsize, {
    change_ui_class(".plotsize_field", "inline")
})
shiny::observeEvent(input$subset_corpus, {
    change_ui_class(".subset_field", "inline")
})
shiny::observeEvent(input$more_terms_button, {
    change_ui_class(".more_terms_field", "inline")
})
shiny::observeEvent(input$antall_linjer, {
    change_ui_class(".additional_search_terms", "inline")
})
