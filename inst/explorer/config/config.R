# Data set-up -------------------------------------------------------------

loaded_data <- getShinyOption("corporaexplorer_data")

# Ugly hack because of testthat's "dry run" with empty data before testing
if(is.null(loaded_data)) {
    loaded_data <-
        corporaexplorer::prepare_data("testthat has a 'dry run' of sorts, resulting in weird behaviour.",
                                      corpus_name = "Not supposed to ever be launched as app")
}

source("./config/backwards_compatibility.R", local = TRUE)

# Constants ---------------------------------------------------------------

source("./config/constants.R", local = TRUE)
source("./config/config_convenience_functions.R", local = TRUE)

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

UI_FILTERING_CHECKBOXES <- loaded_data$columns_for_ui_checkboxes

# Search options from function arguments ----------------------------------

search_options <- shiny::getShinyOption("corporaexplorer_search_options")


if (NO_MATRIX == FALSE) {
    if (!is.null(search_options$use_matrix)) {
        if (is.logical(search_options$use_matrix)) {
            NO_MATRIX <- !search_options$use_matrix
        }
    }
}

OPTIONAL_INFO_TO_CONSOLE <- FALSE
if (!is.null(search_options$optional_info)) {
    if (is.logical(search_options$optional_info)) {
        OPTIONAL_INFO_TO_CONSOLE <- search_options$optional_info
    }
}

SAFE_SEARCH <- TRUE
if (!is.null(search_options$allow_unreasonable_patterns)) {
    if (is.logical(search_options$allow_unreasonable_patterns)) {
        SAFE_SEARCH <- !search_options$allow_unreasonable_patterns
    }
}

# Initialising
USE_ONLY_STRINGR <- FALSE
USE_ONLY_RE2 <- FALSE

if (!is.null(search_options$regex_engine)) {
    if (search_options$regex_engine == "stringr") {
        USE_ONLY_STRINGR <- TRUE
    } else if (search_options$regex_engine == "re2") {
        USE_ONLY_RE2 <- TRUE
    }
}

# Safety precaution:
if (USE_ONLY_STRINGR == TRUE & USE_ONLY_RE2 == TRUE) {
    USE_ONLY_RE2 <- FALSE
}

# UI options from function arguments --------------------------------------

ui_options <- shiny::getShinyOption("corporaexplorer_ui_options")

CORPUS_MAP_COLUMN_WIDTH_PCT <- 50
if (!is.null(ui_options$corpus_map_column_width)) {
    if (is.numeric(ui_options$corpus_map_column_width)) {
        if (ui_options$corpus_map_column_width >= 30 & ui_options$corpus_map_column_width <= 70) {
            CORPUS_MAP_COLUMN_WIDTH_PCT <- as.integer(ui_options$corpus_map_column_width)
        }
    }
}

# Plot options from function arguments ------------------------------------

plot_options <- shiny::getShinyOption("corporaexplorer_plot_options")

PLOT_SIZE_FACTOR <- 15
if (!is.null(plot_options$plot_size_factor)) {
    if (is.numeric(plot_options$plot_size_factor)) {
        if (plot_options$plot_size_factor > 0) {
            PLOT_SIZE_FACTOR <- PLOT_SIZE_FACTOR * plot_options$plot_size_factor
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

MAIN_COLOURS <- c("red", "blue", "green", "purple", "orange", "gray")
if (!is.null(plot_options$colours)) {
    MAIN_COLOURS <- create_colours_from_input(plot_options$colours,
                                              MAIN_COLOURS)
}
MY_COLOURS <- rep(MAIN_COLOURS, 10)

if (!is.null(plot_options$tile_length)) {
    if (plot_options$tile_length == "uniform") {
        loaded_data$original_data$data_dok$Tile_length <- 1
    }
}

# Extra boolean from function arguments -----------------------------------

INCLUDE_EXTRA <- FALSE
if (!is.null(shiny::getShinyOption("corporaexplorer_extra"))) {
    INCLUDE_EXTRA <- shiny::getShinyOption("corporaexplorer_extra")
    loaded_data$original_data$data_dok$Extra_tab_text <- ""
}

# Start-up plot size ------------------------------------------------------

INITIAL_PLOT_SIZE <- plot_size(loaded_data$original_data$data_dok,
                               DATE_BASED_CORPUS)

# Pre-filled sidebar input from function argument -------------------------

source("./config/sidebar_input_values_from_function_call.R", local = TRUE)
