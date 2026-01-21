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
        cx_extra_tab_text(
          session_variables[[modus]],
          min_rad,
          search_arguments$extra_chart_terms
        ),
        "\n",
        "<br>"
      ),
      unique(search_arguments$terms_highlight),
      MY_COLOURS,
      search_arguments$case_sensitive
    )
  })
}
