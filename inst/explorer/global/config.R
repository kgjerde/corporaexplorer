# Data set-up -------------------------------------------------------------

loaded_data <- eval(as.name(getShinyOption("corporaexplorer_data")))

source("./global/backwards_compatibility.R", local = TRUE)

# Constants ---------------------------------------------------------------

source("./global/constants.R", local = TRUE)

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
