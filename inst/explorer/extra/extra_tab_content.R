create_extra_tab_content <- function(mode, min_rad) {
  if (mode == "data_dok") {
    modus <- mode
  } else if (mode == "data_365") {
    modus <- "data_day"
  }

  set_extra_tab_title(plot_mode$mode, min_rad)

  output$extra <- shiny::renderText({
    highlight_document(
      stringr::str_replace_all(
        session_variables[[modus]]$Extra_tab_text[min_rad],
        "\n",
        "<br>"
      ),
      unique(search_arguments$terms_highlight),
      MY_COLOURS,
      search_arguments$case_sensitive
    )
  })
}
