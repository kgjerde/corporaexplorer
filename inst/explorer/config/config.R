# Data set-up -------------------------------------------------------------

loaded_data <- getShinyOption("corporaexplorer_data")

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
    CORPUS_TITLE <- loaded_data$name
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

## At the momemnt only css arguments here.

# Plot options from function arguments ------------------------------------

plot_options <- shiny::getShinyOption("corporaexplorer_plot_options")

PLOT_SIZE_FACTOR <- 10
if (!is.null(plot_options$plot_size_factor)) {
    if (is.numeric(plot_options$plot_size_factor)) {
        if (plot_options$plot_size_factor > 0) {
            PLOT_SIZE_FACTOR <- 10 * plot_options$plot_size_factor
        }
    }
}

MAX_WIDTH_FOR_ROW <- 75
if (!is.null(plot_options$documents_per_row_factor)) {
    if (is.numeric(plot_options$documents_per_row_factor)) {
        if (plot_options$documents_per_row_factor > 0) {
            MAX_WIDTH_FOR_ROW <- 75 * plot_options$documents_per_row_factor
        }
    }
}

DOCUMENT_TILES <- 50
if (!is.null(plot_options$document_tiles)) {
    if (is.numeric(plot_options$document_tiles)) {
        if (plot_options$document_tiles %in% 1:50) {
            DOCUMENT_TILES <- as.integer(plot_options$document_tiles)
        }
    }
}

if (!is.null(plot_options$max_docs_in_wall_view)) {
    MAX_DOCS_IN_WALL_VIEW <- plot_options$max_docs_in_wall_view
} else {
    MAX_DOCS_IN_WALL_VIEW <- 12000
}

# Pre-filled sidebar input from function argument -------------------------

source("./config/sidebar_input_values_from_function_call.R", local = TRUE)
