shiny::tags$head(
  shiny::includeCSS("js_css/explorer_css.css"),
  shiny::includeScript("js_css/enter_search.js"),
  shiny::includeScript("js_css/jquery.scrollTo.js"),
  shiny::includeScript("js_css/search_terms_legend.js"),
  shiny::includeScript("js_css/fullscreen_click_close.js"),
  shiny::includeScript("js_css/column_width.js"),
  if (INCLUDE_FIND_IN_TEXT) shiny::includeScript("js_css/doc_find.js")
)
