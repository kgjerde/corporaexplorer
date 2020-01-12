# Reactive behaviour ------------------------------------------------------
shiny::observe({
  if (input$corpus_box == "Corpus info" &
    session_variables$created_info == FALSE) {
    if (search_arguments$all_ok) {
      local_flag <- FALSE
      if (INCLUDE_EXTRA == TRUE) {
        if (search_arguments$extra_plot != "regular") {
          INFO_MODE <- "extra"
          local_flag <- TRUE
          start_df_list <- cx_extra_create_df_for_info(
            session_variables$data_dok,
            search_arguments$extra_chart_terms,
            search_arguments$case_sensitive
          )
        }
      }

      if (local_flag == FALSE) {
        INFO_MODE <- "regular"
        start_df_list <- create_df_for_info(
          session_variables,
          search_arguments,
          plot_mode$mode
        )
      }

    }

    # Info til infofane
    output$corpus_info <- shiny::renderText({
      source("./server/2_event_search_button/check_search_arguments.R",
        local = TRUE
      )
      # Flagging that validation passed and that therefore
      # also plot below can be displayed:
      session_variables$stop_info_tab <- FALSE
      # Potentially overriding flag if extra
      if (INFO_MODE == "extra") {
        if (identical(search_arguments$extra_chart_terms, "")) {
          session_variables$stop_info_tab <- TRUE
        }
      }

      # corpus_info_text()
      show_corpus_info_text(
        search_arguments,
        session_variables,
        loaded_data$original_data$data_dok,
        start_df_list
      )
    })

# Table title -------------------------------------------------------------

    output$search_results <- shiny::renderText({
      if (session_variables$stop_info_tab == FALSE) {
        if (info_terms_exist(search_arguments, INFO_MODE)) {
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

# Table -------------------------------------------------------------------

    output$TABLE <- shiny::renderTable({
      if (session_variables$stop_info_tab == FALSE) {
        if (info_terms_exist(search_arguments, INFO_MODE)) {
          show_corpus_info_table(
            search_arguments = search_arguments,
            session_variables = session_variables,
            start_df_list
          )
        }
      }
    }, na = "\u2013", digits = 2, width = "100%")


# Condition: not one-group, non-date corpus -------------------------------

  if (ONLY_ONE_GROUP_IN_NON_DATE_BASED_CORPUS == FALSE) {

# Plot title --------------------------------------------------------------

    output$info_plot_title <- shiny::renderText({
      if (session_variables$stop_info_tab == FALSE) {
        if (info_terms_exist(search_arguments, INFO_MODE)) {
          shinyjs::showElement("edit_info_plot_legend_keys")
          if (corpus_is_filtered(search_arguments,
                                 session_variables,
                                 loaded_data$original_data$data_dok)) {
            plot_title <- paste(
              "<hr>",
              "<h4>Search results chart (based on filtered corpus) \u2013 hits per year</h4>"
            )
          } else {
            plot_title <- paste("<hr>",
                                "<h4>Search results chart \u2013 hits per year</h4>")
          }
          if (DATE_BASED_CORPUS == FALSE) {
            plot_title <- stringr::str_replace(plot_title,
                                               "year",
                                               "group")
          }
          plot_title
        }
      }
    })


# Plot --------------------------------------------------------------------

    output$corpus_info_plot <- shiny::renderPlot({
      if (session_variables$stop_info_tab == FALSE) {
        if (nrow(start_df_list$start_df) != 0) {
          session_variables$corpus_info_plot <- corpus_info_plot(start_df_list, search_arguments, INFO_MODE)

          session_variables$corpus_info_plot
        }
      } else {
        NULL
      }
    })

# Edit legend key text input UI -------------------------------------------

    output$column_info_names_ui <- shiny::renderUI({
      ui_list <- lapply(seq_along(start_df_list$full_terms), function(i) {
        id <- paste0("info_legend_", i)
        shiny::textInput(id,
          label = NULL,
          value = start_df_list$full_terms[i]
        )
      })

      for (i in seq_along(start_df_list$full_terms)) {
        ui_list[[i]][["children"]][[2]][["attribs"]][["style"]] <-
          paste0(
            "
  padding-left:10px;
  padding-top:10px;
  padding-right:10px;
  padding-bottom:10px;
  margin-top:-1em;
  margin-bottom:-1em;
  resize:none;
  height:25px;
  color:white;
  width:75%;
  ",
            paste0("background-color:", MY_COLOURS[i])
          )
      }

      ui_list
    })


    session_variables$created_info <- TRUE
  }
  }
})

# Event: update button ----------------------------------------------------

shiny::observeEvent(input$update_info_plot_legend_keys, {
  new_legend_terms <- collect_info_plot_legends(search_arguments$terms_highlight)

  output$corpus_info_plot <- shiny::renderPlot({
    shiny::validate(shiny::need(
      length(new_legend_terms) == length(unique(new_legend_terms)),
      paste("\nMake sure the edited legend keys are all unique.")
    ))

    shiny::validate(shiny::need(
      !("" %in% new_legend_terms),
      paste("\nLegend keys cannot be empty.")
    ))

    session_variables$corpus_info_plot[["data"]][["Term"]] <-
      plyr::mapvalues(
        session_variables$corpus_info_plot[["data"]][["Term"]],
        levels(session_variables$corpus_info_plot[["data"]][["Term"]]),
        new_legend_terms
      )

    session_variables$corpus_info_plot
  })
})

