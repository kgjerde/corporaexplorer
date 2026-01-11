# Functions for corpus map navigation -------------------------------------

# Compute sorted row indices for navigable days (calendar view only)
# Called after search to populate cache
compute_navigable_days <- function() {
  data <- session_variables$data_365
  if (is.null(data)) return(NULL)

  # Valid days: not fake, has documents (Day_without_docs is NA when has docs)
  valid_mask <- data$Invisible_fake_date == FALSE & is.na(data$Day_without_docs)
  valid_rows <- which(valid_mask)
  valid_dates <- data$Date[valid_rows]

  # Sort chronologically
  valid_rows[order(valid_dates)]
}

# Reset navigation state (called at start of new search)
reset_corpus_navigation <- function() {
  session_variables$current_min_rad <- NULL
  session_variables$navigable_days <- NULL
  shinyjs::disable("nav_prev_day")
  shinyjs::disable("nav_next_day")
  shinyjs::disable("nav_prev_doc")
  shinyjs::disable("nav_next_doc")
  shinyjs::runjs("$('#doc_nav_arrows').hide();")
  shinyjs::runjs("$('#nav_pos_day').text('');")
  shinyjs::runjs("$('#nav_pos_doc').text('');")
}

# Update navigation index (called after data is updated)
update_navigable_days <- function() {
  session_variables$navigable_days <- compute_navigable_days()
}

# Calculate current position among valid items (returns list with pos and total)
get_navigation_position <- function(current) {
  if (plot_mode$mode == "data_365") {
    pos <- which(session_variables$navigable_days == current)
    total <- length(session_variables$navigable_days)
  } else {
    # data_dok: simple sequential
    pos <- current
    total <- nrow(session_variables$data_dok)
  }

  list(pos = pos, total = total)
}

# Select and display a row from the corpus map
# Called by click handler and navigation arrows
select_corpus_row <- function(min_rad) {
  if (length(min_rad) == 0) return()

  # Store current position for navigation
  session_variables$current_min_rad <- min_rad

  if (plot_mode$mode == "data_365") {
    if (session_variables[[plot_mode$mode]]$Invisible_fake_date[min_rad] == FALSE &
        is.na(session_variables[[plot_mode$mode]]$Day_without_docs[min_rad])) {
      source("./server/3_event_corpus_map_click/UI_element_control_data_365.R", local = TRUE)
      source("./server/3_event_corpus_map_click/preparing_day_corpus.R", local = TRUE)
      source("./server/3_event_corpus_map_click/title_list.R", local = TRUE)
      source("./server/3_event_corpus_map_click/rendering_day_corpus_map.R", local = TRUE)
      source("./server/3_event_corpus_map_click/js_auto_scroll.R", local = TRUE)
      update_nav_arrows()
    }
  } else if (plot_mode$mode == "data_dok") {
    source("./server/3_event_corpus_map_click/UI_element_control_data_dok.R", local = TRUE)
    source("./server/3_event_corpus_map_click/display_document_text.R", local = TRUE)
    source("./server/3_event_corpus_map_click/document_info_tab_data_dok.R", local = TRUE)
    source("./server/3_event_corpus_map_click/document_visualisation.R", local = TRUE)
    if (INCLUDE_EXTRA == TRUE) {
      create_extra_tab_content(plot_mode$mode, min_rad)
    }
    source("./server/3_event_corpus_map_click/js_auto_scroll.R", local = TRUE)
    update_nav_arrows()
  }
}

# Find next/previous valid row for navigation
find_adjacent_row <- function(current, direction) {
  if (plot_mode$mode == "data_365") {
    # Use cached chronological sequence
    current_idx <- which(session_variables$navigable_days == current)
    if (length(current_idx) == 0) return(NULL)

    next_idx <- current_idx + direction
    if (next_idx >= 1 && next_idx <= length(session_variables$navigable_days)) {
      return(session_variables$navigable_days[next_idx])
    }
    return(NULL)
  } else {
    # data_dok: simple sequential navigation
    next_row <- current + direction
    if (next_row >= 1 && next_row <= nrow(session_variables$data_dok)) {
      return(next_row)
    }
    return(NULL)
  }
}

# Check if navigation is possible in given direction
can_navigate <- function(direction) {
  current <- session_variables$current_min_rad
  if (is.null(current)) return(FALSE)
  !is.null(find_adjacent_row(current, direction))
}

# Update navigation arrow states (enable/disable) and position indicator
update_nav_arrows <- function() {
  current <- session_variables$current_min_rad

  if (plot_mode$mode == "data_365") {
    # Day corpus box navigation
    if (is.null(current)) {
      shinyjs::disable("nav_prev_day")
      shinyjs::disable("nav_next_day")
      shinyjs::runjs("$('#nav_pos_day').text('');")
    } else {
      if (can_navigate(-1)) shinyjs::enable("nav_prev_day") else shinyjs::disable("nav_prev_day")
      if (can_navigate(1)) shinyjs::enable("nav_next_day") else shinyjs::disable("nav_next_day")
      # Update position indicator
      nav_pos <- get_navigation_position(current)
      pos_text <- paste0(nav_pos$pos, "/", nav_pos$total)
      shinyjs::runjs(sprintf("$('#nav_pos_day').text('%s');", pos_text))
    }
  } else {
    # Document box navigation
    shinyjs::runjs("$('#doc_nav_arrows').show();")
    if (is.null(current)) {
      shinyjs::disable("nav_prev_doc")
      shinyjs::disable("nav_next_doc")
      shinyjs::runjs("$('#nav_pos_doc').text('');")
    } else {
      if (can_navigate(-1)) shinyjs::enable("nav_prev_doc") else shinyjs::disable("nav_prev_doc")
      if (can_navigate(1)) shinyjs::enable("nav_next_doc") else shinyjs::disable("nav_next_doc")
      # Update position indicator
      nav_pos <- get_navigation_position(current)
      pos_text <- paste0(nav_pos$pos, "/", nav_pos$total)
      shinyjs::runjs(sprintf("$('#nav_pos_doc').text('%s');", pos_text))
    }
  }
}

# Navigation event handlers
shiny::observeEvent(input$nav_prev_day, {
  next_row <- find_adjacent_row(session_variables$current_min_rad, -1)
  if (!is.null(next_row)) select_corpus_row(next_row)
})

shiny::observeEvent(input$nav_next_day, {
  next_row <- find_adjacent_row(session_variables$current_min_rad, 1)
  if (!is.null(next_row)) select_corpus_row(next_row)
})

shiny::observeEvent(input$nav_prev_doc, {
  next_row <- find_adjacent_row(session_variables$current_min_rad, -1)
  if (!is.null(next_row)) select_corpus_row(next_row)
})

shiny::observeEvent(input$nav_next_doc, {
  next_row <- find_adjacent_row(session_variables$current_min_rad, 1)
  if (!is.null(next_row)) select_corpus_row(next_row)
})
