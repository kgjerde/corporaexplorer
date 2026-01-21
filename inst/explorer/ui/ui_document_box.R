shiny::div(
  # Navigation arrows - positioned absolutely in header area
  shiny::div(
    id = "doc_nav_arrows",
    class = "nav-arrows",
    style = "display: none;",
    shiny::actionLink(
      "nav_prev_doc",
      label = NULL,
      icon = shiny::icon("chevron-left"),
      class = "text-secondary px-1"
    ),
    shiny::span(id = "nav_pos_doc", class = "nav-position text-muted"),
    shiny::actionLink(
      "nav_next_doc",
      label = NULL,
      icon = shiny::icon("chevron-right"),
      class = "text-secondary px-1"
    )
  ),
  bslib::navset_card_pill(
    id = "dokumentboks",
    full_screen = TRUE,
    # Empty placeholder - hidden, tabs added dynamically
    bslib::nav_panel(
      title = "",
      value = "placeholder"
    )
  ),
  class = "class_doc_box"
)
