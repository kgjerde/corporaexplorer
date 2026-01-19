
# Adjusting css: ----------------------------------------------------------

# Spacing
# shinyjs::runjs('$(".magic_search").css("margin-top", "-1em")')

# Rendering UI: -----------------------------------------------------------

  output$magic_text_area_ui <- renderUI({

    shiny::tagList(

    shiny::hr(),

    bslib::input_checkbox_group(
        id = "extra_fields",
        label = "Show extra fields?",
        choices = c("Yes" = "Yes"),
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
        bslib::input_radio_buttons(
          id = "extra_plot_mode",
          label = "Heatmap mode",
          choices = c("Regular" = "regular", "Chunks" = "chunkmap")
        )
        )

    )
})
