
# Important for shinytest to work -----------------------------------------
library(corporaexplorer)

# Data set-up -------------------------------------------------------------

loaded_data <- corporaexplorer::test_data

source("./global/backwards_compatibility.R", local = TRUE)  # TODO should noe be ncessary in tests.

# Constants ---------------------------------------------------------------

source("./global/constants.R", local = TRUE)

# From corporaexplorerobject --------------------------------------------

DATE_BASED_CORPUS <- loaded_data$date_based_corpus
# To decide if to display x-axis label in plot:
ONLY_ONE_GROUP_IN_NON_DATE_BASED_CORPUS <- is.null(loaded_data$original_data$grouping_variable) & DATE_BASED_CORPUS == FALSE

INFO_COLUMNS <- loaded_data$columns_for_info
NO_MATRIX <- identical(loaded_data$ordvektorer$data_dok, FALSE)
MATRIX_WITHOUT_PUNCTUATION <- loaded_data$ordvektorer$without_punctuation

if (is.null(loaded_data$name)) {
    CORPUS_TITLE <- "Corpus map"
} else {
    CORPUS_TITLE <- paste("Corpus map", "\u2013", loaded_data$name)
}

# From function arguments -------------------------------------------------

NO_MATRIX <- FALSE

OPTIONAL_INFO_TO_CONSOLE <- FALSE

USE_ONLY_STRINGR <- FALSE
USE_ONLY_RE2R <- FALSE

SAFE_SEARCH <- TRUE

# UI options from function arguments --------------------------------------

ui_options <- NULL  # To avoid errors when later checking for !is.null css elements

MAX_DOCS_IN_WALL_VIEW <- 12000
