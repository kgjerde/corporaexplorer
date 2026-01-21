add_tab_extra <- function(dok_or_365) {
  shiny::appendTab(
    'dokumentboks',
    tab = bslib::nav_panel(
      title = shiny::textOutput('document_box_extra'),
      value = "document_box_extra",

      shiny::htmlOutput(
        outputId = "extra",
        container = shiny::tags$div,
        class = paste0("boxed_doc_data_", dok_or_365)
      )
    ),

    select = FALSE,
    menuName = NULL,
    session = shiny::getDefaultReactiveDomain()
  )
}

remove_tab_extra <- function() {
  shiny::removeTab(
    'dokumentboks',
    target = "document_box_extra",
    session = shiny::getDefaultReactiveDomain()
  )
}

set_extra_tab_title <- function(mode, min_rad) {
  if (mode == "data_dok") {
    tab_title <- "Extra"
  } else if (mode == "data_365") {
    tab_title <- paste0("Document ", min_rad, " \u2013 ", "Extra")
  }
  output$document_box_extra <- shiny::renderText({
    tab_title
  })
}
