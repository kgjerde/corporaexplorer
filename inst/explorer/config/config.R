# Data set-up -------------------------------------------------------------

loaded_data <- eval(as.name(getShinyOption("corporaexplorer_data")))

source("./config/backwards_compatibility.R", local = TRUE)

# Constants ---------------------------------------------------------------

source("./config/constants.R", local = TRUE)

# From corporaexplorerobject --------------------------------------------

DATE_BASED_CORPUS <- loaded_data$date_based_corpus
contains_grouping_variable <-
    !is.null(loaded_data$original_data$grouping_variable)
# To decide if to display x-axis label in plot:
ONLY_ONE_GROUP_IN_NON_DATE_BASED_CORPUS <-
    contains_grouping_variable == FALSE & DATE_BASED_CORPUS == FALSE

INFO_COLUMNS <- loaded_data$columns_for_info
NO_MATRIX <- identical(loaded_data$ordvektorer$data_dok, FALSE)
MATRIX_WITHOUT_PUNCTUATION <- loaded_data$ordvektorer$without_punctuation

if (is.null(loaded_data$name)) {
    CORPUS_TITLE <- "Corpus map"
} else {
    CORPUS_TITLE <- paste("Corpus map", "\u2013", loaded_data$name)
}

# From function arguments -------------------------------------------------

if (NO_MATRIX == FALSE) {
    NO_MATRIX <- !shiny::getShinyOption("corporaexplorer_use_matrix")
}

OPTIONAL_INFO_TO_CONSOLE <- shiny::getShinyOption("corporaexplorer_optional_info")

SAFE_SEARCH <- !shiny::getShinyOption("corporaexplorer_allow_unreasonable_patterns")

# Initialising
USE_ONLY_STRINGR <- FALSE
USE_ONLY_RE2R <- FALSE

if (shiny::getShinyOption("corporaexplorer_regex_engine") == "stringr") {
    USE_ONLY_STRINGR <- TRUE
} else if (shiny::getShinyOption("corporaexplorer_regex_engine") == "re2r") {
    USE_ONLY_RE2R <- TRUE
}

# Safety precaution:
if (USE_ONLY_STRINGR == TRUE & USE_ONLY_RE2R == TRUE) {
    USE_ONLY_RE2R <- FALSE
}

# UI options from function arguments --------------------------------------

ui_options <- shiny::getShinyOption("corporaexplorer_ui_options")

if (!is.null(ui_options$MAX_DOCS_IN_WALL_VIEW)) {
    MAX_DOCS_IN_WALL_VIEW <- ui_options$MAX_DOCS_IN_WALL_VIEW
} else {
    MAX_DOCS_IN_WALL_VIEW <- 12000
}


# Pre-filled sidebar input from function argument -------------------------

source("./config/sidebar_input_values_from_function_call.R", local = TRUE)
