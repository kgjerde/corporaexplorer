
# Setting up data and constants -------------------------------------------

abc <- eval(as.name(shiny::getShinyOption("corporaexplorer_download_data")))

if (class(abc) == "corporaexplorerobject") {
  INFO_COLUMNS <- abc$columns_for_info
  abc <- abc$original_data$data_dok
  abc$Text <- abc$Text_original_case

}

my_colours <-
  rep(c("red", "blue", "green", "purple", "orange", "gray"), 10)

MAX_DOCS_FOR_HTML <-   shiny::getShinyOption("corporaexplorer_download_max_html")


