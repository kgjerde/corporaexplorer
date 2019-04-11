# Data set-up -------------------------------------------------------------

loaded_data <- eval(as.name(getShinyOption("corporaexplorer_data")))

source("./global/backwards_compatibility.R", local = TRUE)

# Constants ---------------------------------------------------------------

source("./global/constants.R", local = TRUE)

# From corporaexplorerobject --------------------------------------------

INFO_COLUMNS <- loaded_data$columns_for_info
NO_MATRIX <- identical(loaded_data$ordvektorer$data_dok, FALSE)
MATRIX_WITHOUT_PUNCTUATION <- loaded_data$ordvektorer$without_punctuation

if (is.null(loaded_data$name)) {
    CORPUS_TITLE <- "Corpus map"
} else {
    CORPUS_TITLE <- paste("Corpus map", "–", loaded_data$name)
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
