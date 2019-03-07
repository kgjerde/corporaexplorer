
# Import for shinytest to work: -------------------------------------------
library(corpusexplorationr)

# Setting up data and constants -------------------------------------------

abc <- test_data

INFO_COLUMNS <- abc$columns_for_info
abc <- abc$original_data$data_dok
abc$Text <- abc$Text_case

my_colours <-
  rep(c("red", "blue", "green", "purple", "orange", "gray"), 10)

MAX_DOCS_FOR_HTML <- 400


