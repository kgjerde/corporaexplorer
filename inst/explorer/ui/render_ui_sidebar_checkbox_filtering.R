if (!is.null(UI_FILTERING_CHECKBOXES)) {

# Creating one UI element for each column with checkboxes -----------------

  list_of_filtering_columns_ui <- list()
  for (i in seq_along(UI_FILTERING_CHECKBOXES$column_names)) {
    list_of_filtering_columns_ui[[i]] <-
      conditionalPanel(
        condition = "input.subset_group == true",

        div(
          shiny::checkboxGroupInput(
            inputId = paste0("type_", i),
            choices = UI_FILTERING_CHECKBOXES$values[[i]],
            selected = UI_FILTERING_CHECKBOXES$values[[i]],
            inline = TRUE,
            label = if (rlang::is_named(UI_FILTERING_CHECKBOXES$column_names[i])) {
              names(UI_FILTERING_CHECKBOXES$column_names[i])
            } else {
              UI_FILTERING_CHECKBOXES$column_names[i]
            }
          ),
          class = "filtering_checkboxes"
        )
      )
  }

# Rendering UI: -----------------------------------------------------------
## a button to reveal the checkboxes + UIs just generated -----------------

  output$checkbox_filtering_ui <- renderUI({
    shiny::tagList(
      shiny::checkboxInput(
        inputId = "subset_group",
        label = "More filtering options",
        value = FALSE
      ),
      list_of_filtering_columns_ui
    )
  })
}
