
# Setting up data and constants -------------------------------------------

if (!is.null(getOption("shiny.testmode"))) {
  if (getOption("shiny.testmode") == TRUE) {
    library(corpusexplorationr)
    abc <- test_data
  }
} else {
  abc <- eval(as.name(shiny::getShinyOption("corpusexplorationr_download_data")))
}

if (class(abc) == "corpusexplorationobject") {
  INFO_COLUMNS <- abc$columns_for_info
  abc <- abc$original_data$data_dok
  abc$Text <- abc$Text_case

}

my_colours <-
  rep(c("red", "blue", "green", "purple", "orange", "gray"), 10)

MAX_DOCS_FOR_HTML <-   shiny::getShinyOption("corpusexplorationr_download_max_html")


