# Preview of search terms added to filtering ------------------------------
output$filter_by_search_terms_preview <- shiny::renderUI({
  if (isTRUE(input$filter_by_search_terms)) {
    preview_style <- "color: #888; display: block; margin-top: -0.5rem; margin-bottom: 0.5rem;"
    search_terms_raw <- input$search_terms_area

    if (is.null(search_terms_raw) || nchar(trimws(search_terms_raw)) == 0) {
      shiny::tags$small(
        style = preview_style,
        shiny::tags$i("No search terms")
      )
    } else {
      terms <- search_terms_raw %>%
        stringr::str_split("\n") %>%
        unlist() %>%
        .[. != ""]
      shiny::tags$small(
        style = preview_style,
        shiny::tags$i("Added to filtering:"),
        lapply(terms, function(t) shiny::tagList(shiny::tags$br(), t))
      )
    }
  }
})

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
            label = if (
              rlang::is_named(UI_FILTERING_CHECKBOXES$column_names[
                i
              ])
            ) {
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
