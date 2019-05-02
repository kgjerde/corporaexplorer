
# Constants ---------------------------------------------------------------

MY_COLOURS <-
    rep(c("red", "blue", "green", "purple", "orange", "gray"), 10)

CHARACTER_LIMIT <- 200

PUNCTUATION_REGEX <- '[\\Q.!"#$%&\'()*+,/:;<=>?@[]^_`{|}~\u00ab\u00bb\u2026\\E]|\\\\.|\\d' # Note the use of \\Q.\\E

DOCUMENT_TILES <- 50

EMPTY_DAY_PLOT_HEIGHT <- 20

MAX_DOCS_IN_WALL_VIEW <- 12000

# Constants for plot size and plot design ---------------------------------

MAX_WIDTH_FOR_ROW <- 75  # Must be > 0
X_FACTOR <- 10  # Multiplication element in function_plot_size()
