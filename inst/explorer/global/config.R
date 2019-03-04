# Data set-up -------------------------------------------------------------

if (!is.null(getOption("shiny.testmode"))) {
  if (getOption("shiny.testmode") == TRUE) {
    library(corpusexplorationr)
    loaded_data <- test_data
  }
} else {
  loaded_data <- eval(as.name(getShinyOption("data")))
}


# Constants ---------------------------------------------------------------

MY_COLOURS <-
    rep(c("red", "blue", "green", "purple", "orange", "gray"), 10)

CHARACTER_LIMIT <- 200

PUNCTUATION_REGEX <- '[\\Q.!"#$%&\'()*+,/:;<=>?@[]^_`{|}~\u00ab\u00bb\u2026\\E]|\\\\.|\\d' # Note the use of \\Q.\\E


# From corpusexplorationobject --------------------------------------------

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
    NO_MATRIX <- !shiny::getShinyOption("use_matrix")
}

OPTIONAL_INFO_TO_CONSOLE <- shiny::getShinyOption("optional_info")

# Initialising
USE_ONLY_STRINGR <- FALSE
USE_ONLY_RE2R <- FALSE

if (shiny::getShinyOption("regex_engine") == "stringr") {
    USE_ONLY_STRINGR <- TRUE
} else if (shiny::getShinyOption("regex_engine") == "re2r") {
    USE_ONLY_RE2R <- TRUE
}

# Safety precaution:
if (USE_ONLY_STRINGR == TRUE & USE_ONLY_RE2R == TRUE) {
    USE_ONLY_RE2R <- FALSE
}
