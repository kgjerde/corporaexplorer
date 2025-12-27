
# Important for shinytest2 to work -----------------------------------------
library(corporaexplorer)

# Data set-up -------------------------------------------------------------

loaded_data <- corporaexplorer::test_data

## corporaexplorer::test_data does not need this step,
    # but it tests that new corporaexplorerobjects do not encounter errors here:
source("./config/backwards_compatibility.R", local = TRUE)

# Constants ---------------------------------------------------------------

source("./config/constants.R", local = TRUE)

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

UI_FILTERING_CHECKBOXES <- NULL

# Search options from function arguments ----------------------------------

NO_MATRIX <- FALSE

OPTIONAL_INFO_TO_CONSOLE <- FALSE

USE_ONLY_STRINGR <- FALSE
USE_ONLY_RE2 <- FALSE

SAFE_SEARCH <- TRUE

# Plot options from function arguments ------------------------------------

PLOT_SIZE_FACTOR <- 15

MAX_WIDTH_FOR_ROW <- 75

DOCUMENT_TILES <- 40

ui_options <- NULL  # To avoid errors when later checking for !is.null css elements

MAX_DOCS_IN_WALL_VIEW <- 12000

MAIN_COLOURS <- c("red", "blue", "green", "purple", "orange", "gray")
MY_COLOURS <- rep(MAIN_COLOURS, 10)

# Extra boolean from function arguments -----------------------------------

INCLUDE_EXTRA <- FALSE

# Start-up plot size ------------------------------------------------------

INITIAL_PLOT_SIZE <- plot_size(loaded_data$original_data$data_dok,
                               DATE_BASED_CORPUS)

# Pre-filled sidebar input from function argument -------------------------

source("./config/sidebar_input_values_from_function_call.R", local = TRUE)
