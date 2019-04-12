# Reactive behaviour ------------------------------------------------------

shiny::observe({
  if (input$corpus_box == "Corpus info" &
    session_variables$created_info == FALSE) {

    if (search_arguments$all_ok) {
      
      start_df_list <- create_df_for_info(session_variables,
                                          search_arguments,
                                          plot_mode$mode)
    }
    
    # Info til infofane
    output$corpus_info <- shiny::renderText({
      source("./server/2_event_search_button/check_search_arguments.R",
        local = TRUE
      )
      # Flagging that validation passed and that therefore
      # also plot below can be displayed:
      session_variables$stop_info_tab <- FALSE
      # corpus_info_text()
      show_corpus_info_text(
        search_arguments,
        session_variables,
        loaded_data$original_data$data_dok,
        start_df_list
      )
    })

    output$search_results <- shiny::renderText({
      if (session_variables$stop_info_tab == FALSE) {
        if (highlight_terms_exist(search_arguments)) {
          if (corpus_is_filtered(
            search_arguments,
            session_variables,
            loaded_data$original_data$data_dok
          )) {
            paste(
              "<hr>",
              "<h4>Search results (in filtered corpus)</h4>"
            )
          } else {
            paste(
              "<hr>",
              "<h4>Search results</h4>"
            )
          }
        }
      }
    })

    output$TABLE <- shiny::renderTable({
      if (session_variables$stop_info_tab == FALSE) {
        if (highlight_terms_exist(search_arguments)) {
          show_corpus_info_table(
            search_arguments = search_arguments,
            session_variables = session_variables,
            start_df_list
          )
        }
      }
    }, na = "\u2013", digits = 2, width = "100%")

    output$info_plot_title <- shiny::renderText({
      if (session_variables$stop_info_tab == FALSE) {
        if (highlight_terms_exist(search_arguments)) {
          if (corpus_is_filtered(
            search_arguments,
            session_variables,
            loaded_data$original_data$data_dok
          )) {
            paste(
              "<hr>",
              "<h4>Search results chart (based on filtered corpus) \u2013 hits per year</h4>"
            )
          } else {
            paste(
              "<hr>",
              "<h4>Search results chart \u2013 hits per year</h4>"
            )
          }
        }
      }
    })


    output$corpus_info_plot <- shiny::renderPlot({
      if (session_variables$stop_info_tab == FALSE) {
      if (nrow(start_df_list$start_df) != 0)  {
        corpus_info_plot(start_df_list, search_arguments)
      }
      } else {
        NULL
      }
    })
    session_variables$created_info <- TRUE
  }
})
