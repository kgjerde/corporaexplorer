
# Important for shinytest to work -----------------------------------------
library(corpusexplorationr)

# Data set-up -------------------------------------------------------------

loaded_data <- corpusexplorationr::test_data

# Constants ---------------------------------------------------------------

MY_COLOURS <-
    rep(c("red", "blue", "green", "purple", "orange", "gray"), 10)

CHARACTER_LIMIT <- 200

PUNCTUATION_REGEX <- '[\\Q.!"#$%&\'()*+,/:;<=>?@[]^_`{|}~\u00ab\u00bb\u2026\\E]|\\\\.|\\d' # Note the use of \\Q.\\E

DOCUMENT_TILES <- 50

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

NO_MATRIX <- FALSE

OPTIONAL_INFO_TO_CONSOLE <- FALSE

USE_ONLY_STRINGR <- FALSE
USE_ONLY_RE2R <- FALSE

SAFE_SEARCH <- TRUE

