
# Adjusting css: ----------------------------------------------------------

# Spacing
# shinyjs::runjs('$(".magic_search").css("margin-top", "-1em")')

# Rendering UI: -----------------------------------------------------------

  output$magic_text_area_ui <- renderUI({

    shiny::tagList(

    shiny::hr(),

    shinyWidgets::checkboxGroupButtons(
        inputId = "extra_fields",
        label = NULL,
        choices = list("Show extra fields?" = "Yes"),
        justified = TRUE,
        size = "sm",
        selected = input_arguments_derived$extra_fields
    ),

    conditionalPanel(
        condition = "input.extra_fields == 'Yes'",

        # Search text area
        div(
        shiny::textAreaInput(
            "magic_search_area",
            label = "Extra: Chart sentences",
            placeholder = "pattern--window(--pattern)*",
            value = input_arguments_derived$extra_chart_terms
        ), class = "magic_search"),

        # Filter text area
        shiny::textAreaInput(
            "magic_text_area",
            label = "Extra: Filtering by sentences",
            placeholder = "pattern--window(--pattern)*",
            value = input_arguments_derived$extra_subset_terms
        ),

        # Heatmap choice
        shinyWidgets::radioGroupButtons(
          "extra_plot_mode",
          label = "Heatmap mode",
          choices = list("Regular" = "regular", "Chunks" = "chunkmap"),
          size = "xs",
          justified = TRUE
        )
        )

    )
})
