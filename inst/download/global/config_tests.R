
# Import for shinytest to work: -------------------------------------------
library(corporaexplorer)

# Setting up data and constants -------------------------------------------

abc <- test_data

source("./global/backwards_compatibility.R", local = TRUE)

DATE_BASED_CORPUS <- abc$date_based_corpus

# Regarding titles for html report
contains_grouping_variable <-
  !is.null(abc$original_data$grouping_variable)
if (contains_grouping_variable == TRUE) {
GROUPING_VARIABLE <-
    abc$original_data$grouping_variable
} else {
   GROUPING_VARIABLE <- NA
}

INFO_COLUMNS <- abc$columns_for_info
abc <- abc$original_data$data_dok
abc$Text <- abc$Text_original_case

my_colours <-
  rep(c("red", "blue", "green", "purple", "orange", "gray"), 10)

MAX_DOCS_FOR_HTML <- 400


