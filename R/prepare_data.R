# 1. "Regular" df: 1 doc = 1 row ------------------------------------------

#' Adjusts data frame to corporaexplorer format
#'
#' @param df Data frame with text column (character),
#'   Date column (Date) (if date based corpus),
#'   and
#'   optionally other
#'   columns.
#' @param tile_length_range Numeric vector of length two.
#'   Fine-tune the tile lengths in document wall
#'   and day corpus view. Tile length is calculated by
#'   \code{scales::rescale(nchar(dataset[[text_column]]),
#'   to = tile_length_range,
#'   from = c(0, max(.)))}
#'   Default is \code{c(1, 10)}.
#' @return A tibble ("data_dok")
#' @keywords internal
transform_regular <- function(df, tile_length_range = c(1, 10)) {
  message("Starting.")

  df <- dplyr::arrange(df, Date)

  df$Year_ <- lubridate::year(df$Date)

  df$Tile_length <- nchar(df$Text_column_) %>%
    scales::rescale(to = tile_length_range, from = c(0, max(.)))

  df$cx_ID <- seq_len(nrow(df))

  df$Text_original_case <- df$Text_column_

  df$Text_column_ <-
    stringr::str_to_lower(df$Text_column_) # for søke-purposes

  df <- dplyr::select(df,
                cx_ID,
                Date,
                Text_column_,
                Text_original_case,
                Tile_length,
                Year_,
                sort(colnames(df)[!colnames(df) %in% c("cx_ID",
                                                               "Date",
                                                               "Text_column_",
                                                               "Text_original_case",
                                                               "Tile_length",
                                                               "Year_")]))

  message("Document data frame done.")
  return(df)
}



# 2. 365: 1 day = 1 tile --------------------------------------------------

#' Convert "data_dok" tibble to "data_365" tibble
#'
#' @param new_df A "data_dok" tibble produced by \code{transform_regular}
#'
#' @return A "data_365" tibble.
#' @keywords internal
transform_365 <- function(new_df) {

  df_365 <- new_df['Date'] %>%
    dplyr::distinct() %>%
    dplyr::mutate(Text_column_ = "Date with document in original df")

  min_date <- min(df_365$Date)
  max_date <- max(df_365$Date)

  df_365$Year_ <- lubridate::year(df_365$Date)

  df_365 <-
    padr::pad(df_365,
      interval = "day",
      start_val = as.Date(paste0(min(df_365$Year_), "-01-01")),
      end_val = as.Date(paste0(max(df_365$Year_), "-12-31"))
    )

  df_365$Day_without_docs <- is.na(df_365$Text_column_)

  df_365$Text_column_ <- NULL

  df_365$Day_without_docs[df_365$Day_without_docs == FALSE] <- NA

  df_365$Tile_length <- 1

  df_365$Year_ <- lubridate::year(df_365$Date)

  df_365$Weekday_n <- lubridate::wday(df_365$Date, week_start = 1)

  df_365$Month_n <- lubridate::month(df_365$Date)

  df_365$Yearday_n <- lubridate::yday(df_365$Date)

  df_365 <-
    dplyr::arrange(df_365, Year_, Weekday_n, Yearday_n, Month_n)

  df_365$Invisible_fake_date <- FALSE

  df_365$Invisible_fake_date[df_365$Date < min_date | df_365$Date > max_date] <- TRUE

  df_365_month_dividers <- df_365 %>%
    dplyr::group_by(Year_) %>%
    dplyr::slice(1) %>%
    dplyr::mutate(Diff = Yearday_n - Weekday_n) %>%
    dplyr::filter(Diff > 0) %>%
    dplyr::mutate(Diff = 7 - Diff)

  if (nrow(df_365_month_dividers) != 0) {
    df_365_month_dividers_for_df <- tibble::tibble()
    for (row in seq_len(nrow(df_365_month_dividers))) {
      temp_tib <- tibble::tibble(
        Date = as.Date("8000-01-01"),
        Year_ = df_365_month_dividers$Year_[row],
        Month_n = 1,
        Weekday_n = seq_len(df_365_month_dividers$Diff[row]),
        Yearday_n = sort(-seq_len(df_365_month_dividers$Diff[row]), decreasing = FALSE),
        Invisible_fake_date = TRUE,
        Day_without_docs = TRUE,
        Tile_length = 1
      )
      df_365_month_dividers_for_df <-
        rbind(df_365_month_dividers_for_df, temp_tib)
    }

    df_365_month_dividers_for_df <-
      dplyr::select(df_365_month_dividers_for_df, colnames(df_365))

    df_365 <- rbind(df_365, df_365_month_dividers_for_df)
  }

  df_365 <-
    dplyr::arrange(df_365, Year_, Weekday_n, Yearday_n, Month_n)

  df_365$cx_ID <- seq_len(nrow(df_365))

  df_365 <- dplyr::select(df_365,
                          cx_ID,
                          Date,
                          Year_,
                          Weekday_n,
                          Day_without_docs,
                          Invisible_fake_date,
                          Tile_length
                          )

  message("Calendar data frame done.")
  return(df_365)
}

# 3. Chr vector to 'matrix'/data.table for faster search ------------------

#' Create document term matrix for fast search of single words
#'
#' The characters removed
#'
#' @param df A "data_dok" tibble
#' @param matrix_without_punctuation Should punctuation and digits be stripped
#'   from the text before constructing the document term matrix? If \code{TRUE},
#'   the default:
#' \itemize{
#'     \item The corporaexplorer object will be lighter and most searches in
#'     the corpus exploration app will be faster.
#'     \item Searches including punctuation and digits will be carried out in
#'     the full text documents.
#'     \item The only "risk" with this strategy is that the corpus exploration
#'     app in some cases can produce false positives. E.g. searching for the
#'     term "donkey" will also find the term "don\%key".
#' This should not be a problem for the vast majority of use cases, but if
#' one so desires, there are three different solutions: set this parameter to
#' \code{FALSE}, create a corporaexplorerobject without a matrix by setting
#' the \code{use_matrix} parameter to \code{FALSE}, or run
#' \code{\link[corporaexplorer]{explore}} with the
#' \code{use_matrix} parameter set to \code{FALSE}.
#' }
#'  If \code{FALSE}, the corporaexplorer object will be larger, and most
#'  simple searches will be slower.
#' @return List: 1) Document term matrix (data.table), 2) word vector (character
#'   vector).
#' @keywords internal
matrix_via_r <- function(df, matrix_without_punctuation = TRUE) {
  df <- dplyr::select(df, Text_column_, cx_ID)

  if (matrix_without_punctuation == TRUE) {
    df$Text_column_ <- df$Text_column_ %>%
      # To satisfy R CMD check:
      # I have run stringi::stri_escape_unicode("[\\Q!"#$%&\'()*+,/:;<=>?@[]^_`{|}~«»…\\E]")
      # to see which non-ascii characters had to be replaced
      stringr::str_replace_all(
        '[\\Q!"#$%&\'()*+,/:;<=>?@[]^_`{|}~\u00ab\u00bb\u2026\\E]',
        ""
      ) %>%
      stringr::str_replace_all("\\.", " ") %>%
      stringr::str_replace_all("\\d", "")
  }

  df$Text_column_ <- df$Text_column_ %>%
    stringr::str_replace_all("\\s", " ") %>%
    stringr::str_replace_all(" {2,}", " ") %>%
    stringr::str_trim()

  message("Document term matrix: text processed.")

  data.table::setDT(df)
  df <-
    df[, list(word = unlist(stringi::stri_split_fixed(Text_column_, pattern = " "))),
      by =
        cx_ID
    ][,
      list(count = .N),
      by = c("cx_ID", "word")
    ][order(cx_ID, word), ]

  message("Document term matrix: tokenising completed.")

  ord <- unique(df$word) %>% sort()

  message("Document term matrix: word list created.")

  df$word <-
    plyr::mapvalues(df$word, ord, seq_along(ord)) %>%
    as.integer()

  df <- dplyr::select(df, cx_ID, word, count)

  colnames(df) <- c("i", "j", "x")

  df <- data.table::as.data.table(df)

  ## Setter indeks/key på data.table for virkelig lynraskt søk!
  #
  data.table::setkey(df, j)
  data.table::setindex(df, i)

  message("Document term matrix done.")

  return(list(df, ord))
}


#' Split up returned list from matrix_via_r()
#'
#' @param returned_list Returned list from matrix_via_r()
#'
#' @return Document term matrix (data.table).
#' @keywords internal
get_matrix <- function(returned_list) {
  return(returned_list[[1]])
}

#' Split up returned list from matrix_via_r()
#'
#' @param returned_list Returned list from matrix_via_r()
#'
#' @return Word vector (character vector).
#' @keywords internal
get_term_vector <- function(returned_list) {
  return(returned_list[[2]])
}

# 4. Helper function ------------------------------------------------------

#' Values for custom UI sidebar checkbox filtering
#'
#' @param columns_for_ui_checkboxes Character. Character or factor column(s) in dataset.
#'   Include sets of checkboxes in the app sidebar for
#'   convenient filtering of corpus.
#'   Typical useful for columns with a small set of unique
#'   (and short) values.
#'   Checkboxes will be arranged by \code{sort()},
#'   unless \code{columns_for_ui_checkboxes}
#'   is a vector of factors, in which case the order will be according to
#'   factor level order (easy relevelling with \code{forcats::fct_relevel()}).
#'   To use a different
#'   label in the sidebar than the columnn name,
#'   simply pass a named character vector to \code{columns_for_ui_checkboxes}.
#'   If \code{columns_for_ui_checkboxes} includes a column which is not
#'   present in dataset, it will be ignored.
#' @inheritParams transform_365
#'
#' @return List: column_names; values. Or NULL.
#' @keywords internal
include_columns_for_ui_checkboxes <-
  function(new_df, columns_for_ui_checkboxes = NULL) {
    column_names <-
      columns_for_ui_checkboxes[columns_for_ui_checkboxes %in% colnames(new_df)]
    if (length(column_names) == 0) {
      return(NULL)
    }

    values <- vector("list", length(column_names))
    for (i in seq_along(column_names)) {
      if (is.factor(new_df[[column_names[i]]])) {
        values[[i]] <-
          levels(new_df[[column_names[i]]])
      } else {
        values[[i]] <- new_df[[column_names[i]]] %>%
          as.character() %>%
          unique() %>%
          sort()
      }
    }
    return(list(column_names = column_names, values = values))
  }

# 4. Main function --------------------------------------------------------

# https://github.com/tidyverse/dplyr/blob/master/R/tbl-cube.r for tips on documentation

# Generic -----------------------------------------------------------------

#' Prepare data for corpus exploration
#'
#' Convert data frame or character vector to a ‘corporaexplorerobject’
#'   for subsequent exploration.
#'
#' @param ... Ignored.
#' @return A \code{corporaexplorer} object to be passed as argument to
#'   \code{\link[corporaexplorer]{explore}}.
#' @export
prepare_data <- function(dataset, ...) {
   UseMethod("prepare_data")
 }

# Method for data.frame ---------------------------------------------------

#' @export
#' @rdname prepare_data
#' @param dataset Object to be converted to a corporaexplorerobject.
#'   Converts a data frame with a specified column containing text (default column name: "Text") (class
#'   character), and optionally other columns.
#'   If \code{date_based_corpus} is \code{TRUE} (the default),
#'   \code{dataset} must contain a column "Date" (of class Date).
#' @param date_based_corpus Logical. Set to \code{FALSE} if the corpus
#'   is not to be organised according to document dates.
#' @param text_column Character. Default: "Text".
#'   The column in \code{dataset} containing texts to be explored.
#' @param grouping_variable Character string indicating column name in dataset.
#'   If date_based_corpus is TRUE, this argument is ignored.
#'   If date_based_corpus is FALSE, this argument is used to group the documents,
#'   e.g., if dataset is organised by chapters belonging to different books.
#'   The order of groups in the app is determined as follows:
#'   \itemize{
#'   \item If grouping_variable is a factor column, the factor levels determine the order.
#'   \item If grouping_variable is not a factor, the order is determined by the
#'     sequence in which unique values first appear in the dataset.}
#' @param within_group_identifier Character string indicating column name in \code{dataset}.
#'  If \code{date_based_corpus} is \code{TRUE}, this argument is ignored.
#'  If \code{date_based_corpus} is \code{FALSE},
#'  \code{"sequential"}, the default, means the rows in each group are assigned
#'  a numeric sequence 1:n where n is the number of rows in the group.
#'  Used in document tab title in non-date based corpora.
#' @param columns_doc_info Character vector. The columns from \code{dataset} to display in
#'   the "document information" tab in the corpus exploration app. By default
#'   "Date", "Title" and "URL" will be
#'   displayed, if included. If \code{columns_doc_info} includes a column which is not
#'   present in dataset, it will be ignored.
#' @param corpus_name Character string with name of corpus.
#' @param use_matrix Logical. Should the function create a document term matrix
#'   for fast searching? If \code{TRUE}, data preparation will run longer and demand
#'   more memory. If \code{FALSE}, the returning corporaexplorerobject will be more light-weight, but
#'   searching will be slower.
#' @inheritParams transform_regular
#' @inheritParams matrix_via_r
#' @inheritParams include_columns_for_ui_checkboxes
#' @details For data.frame: Each row in \code{dataset} is treated as a base differentiating unit in the corpus,
#'   typically chapters in books, or a single document in document collections.
#'   The following column names are reserved and cannot be used in \code{dataset}:
#'   "Date_",
#'   "cx_ID",
#'   "Text_original_case",
#'   "Text_column_",
#'   "Tile_length",
#'   "Year_",
#'   "cx_Seq",
#'   "Weekday_n",
#'   "Day_without_docs",
#'   "Invisible_fake_date",
#'   "Tile_length".
#' @examples
#' ## From data.frame
#' # Constructing test data frame:
#' dates <- as.Date(paste(2011:2020, 1:10, 21:30, sep = "-"))
#' texts <- paste0(
#'   "This is a document about ", month.name[1:10], ". ",
#'   "This is not a document about ", rev(month.name[1:10]), "."
#' )
#' titles <- paste("Text", 1:10)
#' test_df <- tibble::tibble(Date = dates, Text = texts, Title = titles)
#'
#' # Converting to corporaexplorerobject:
#' corpus <- prepare_data(test_df, corpus_name = "Test corpus")
#'
#' if(interactive()){
#' # Running exploration app:
#' explore(corpus)
#' }
prepare_data.data.frame <- function(dataset,
                         date_based_corpus = TRUE,
                         text_column = "Text",
                         grouping_variable = NULL,
                         within_group_identifier = "sequential",
                         columns_doc_info = c("Date", "Title", "URL"),
                         corpus_name = NULL,
                         use_matrix = TRUE,
                         matrix_without_punctuation = TRUE,
                         tile_length_range = c(1, 10),
                         columns_for_ui_checkboxes = NULL,
                         ...) {

# Argument checking general -----------------------------------------------

  if (!all(is.logical(c(
    date_based_corpus,
    use_matrix,
    matrix_without_punctuation
  )))) {
    stop(
      "Hmm. Make sure all arguments that are supposed to be boolean is either TRUE or FALSE.",
      call. = FALSE
    )
  }

  if (!is.data.frame(dataset)) {
    stop(
      "Hmm. Make sure that 'dataset' is a data frame.",
      call. = FALSE
    )
  }

  if (text_column %in% colnames(dataset) == FALSE) {
    stop("Hmm. Make sure that 'dataset' contains the column specified in 'text_column' (defaults to 'Text').",
      call. = FALSE
    )
  }

  if (anyNA(dataset[[text_column]])) {
    stop("Hmm. Make sure that the column specified in 'text_column' (defaults to 'Text') does not contain any NA values.",
      call. = FALSE
    )
  }

  if (!is.character(dataset[[text_column]])) {
    stop("Hmm. Make sure that the column specified in 'text_column' (defaults to 'Text') is a character vector.",
      call. = FALSE
    )
  }

  if (nrow(dataset) == 0) {
    stop("Hmm. corporaexplorer cannot explore an empty corpus. ",
         "Please check 'dataset'.",
      call. = FALSE
    )
  }

  RESERVED_NAMES <- c("cx_ID",
                      "Text_original_case",
                      "Tile_length",
                      "Year_",
                      "cx_Seq",
                      "Text_column_",
                      "Weekday_n",
                      "Day_without_docs",
                      "Invisible_fake_date",
                      "Tile_length"
                      )

  if (any(RESERVED_NAMES %in% colnames(dataset))) {
    stop(
      paste(
        sep = "\n",
        "'dataset' contains reserved column names.",
        "Reserved column names are:",
        paste(RESERVED_NAMES, collapse = "\n")
      ),
      call. = FALSE
    )
  }

  if (is.numeric(tile_length_range) == FALSE |
      length(tile_length_range) != 2) {
    stop("Hmm. Make sure that 'tile_length_range' is a numeric vector of length 2.",
      call. = FALSE
    )
  }

# Argument checking date_based_corpus -------------------------------------

  if (date_based_corpus == TRUE) {

    if ("Date" %in% colnames(dataset) == FALSE) {
      stop("Hmm. Make sure that 'dataset' contains a 'Date' column.",
        call. = FALSE)
    }

    if (lubridate::is.Date(dataset$Date) == FALSE) {
      stop("Hmm. Make sure that 'dataset$Date' is of class 'Date'.",
           call. = FALSE)
    }

    if (anyNA(dataset$Date)) {
      stop("Hmm. Make sure that 'dataset$Date' does not contain any NA values.",
           call. = FALSE)
    }
  }

# Argument checking non_date_based_corpus ---------------------------------

  if (date_based_corpus == FALSE) {

    if (!is.null(grouping_variable)) {
      if (grouping_variable %in% colnames(dataset) == FALSE) {
        stop("'grouping_variable' has to be a column in 'dataset'.",
          call. = FALSE)
      }
    }

  }

# Pre-preparing non_date_based_corpus -------------------------------------

  if (date_based_corpus == FALSE) {
      if ("Date" %in% colnames(dataset) == FALSE) {
          # 'Date' placeholder
          dataset$Date <- as.Date("1882-09-05")
      } else {
          # Temporarily assign 'Date' placeholder
          dataset$Date_ <- dataset$Date
          dataset$Date <- as.Date("1882-09-05")
      }
  }

# Assigning specified text_column -----------------------------------------

dataset$Text_column_ <- dataset[[text_column]]
dataset[[text_column]] <- NULL

# The main function proper ------------------------------------------------

  abc <- transform_regular(dataset, tile_length_range)

  if (date_based_corpus == TRUE) {
    abc_365 <- transform_365(abc)
  } else {
    message("Corpus is not date based. Calendar data frame skipped.")
  }

  if (use_matrix == TRUE) {
    matrix_list_dok <- matrix_via_r(abc, matrix_without_punctuation)
    matrix_dok <- get_matrix(matrix_list_dok)
    ordvektor_dok <- get_term_vector(matrix_list_dok)
    rm(matrix_list_dok)
  } else {
    matrix_dok <- FALSE
    ordvektor_dok <- FALSE
  }


# Post-preparing non_date_based_corpus ------------------------------------

  if (date_based_corpus == FALSE) {
    # Return original 'Date' column, if part of df
    if ("Date_" %in% colnames(abc) == TRUE) {
        abc$Date <- abc$Date_
        abc$Date_ <- NULL
    }

    if (!is.null(grouping_variable)) {
      abc$Year_ <- dataset[[grouping_variable]]
    } else {
      abc$Year_ <- " "
    }

    # Renaming argument
    if (within_group_identifier == "sequential") {
        within_group_identifier <- "cx_Seq"
    }

    if (within_group_identifier %in% c("cx_Seq", colnames(dataset)) == FALSE) {
      stop("'within_group_identifier' must be a column in 'dataset'.",
        call. = FALSE)
    }

    # Order of groups
    if (is.factor(abc$Year_)) {
      order_of_groups <- levels(abc$Year_)
    } else {
      order_of_groups <- unique(abc$Year_)
    }
    abc <- abc %>%
      dplyr::arrange(match(Year_, order_of_groups))

    # Identifier within groups
    if (within_group_identifier == "cx_Seq") {
      abc <- abc %>%
        dplyr::group_by(Year_) %>%
        dplyr::mutate(cx_Seq = 1:dplyr::n())
    } else {
      abc$cx_Seq <- abc[[within_group_identifier]]
    }

  }

  # 5. Putting the 'corporaexplorerobject' together ---------------------

  loaded_data <- list()

  loaded_data$original_data$data_dok <- abc
  if (date_based_corpus == TRUE) {
    loaded_data$original_data$data_365 <- abc_365
  }

  loaded_data$original_matrix$data_dok <- matrix_dok
  loaded_data$ordvektorer$data_dok <- ordvektor_dok
  loaded_data$ordvektorer$without_punctuation <- matrix_without_punctuation

  loaded_data$name <- corpus_name
  loaded_data$columns_for_info <-
    columns_doc_info[columns_doc_info %in% colnames(abc)]

  loaded_data$columns_for_ui_checkboxes <-
    include_columns_for_ui_checkboxes(abc, columns_for_ui_checkboxes)

  # For config constants
  loaded_data$date_based_corpus <- date_based_corpus
  loaded_data$original_data$grouping_variable <- grouping_variable

  # Th column specified as text column
  loaded_data$text_column <- text_column

  # Package version with which object is created
  loaded_data$version <- utils::packageVersion("corporaexplorer")

  class(loaded_data) <- "corporaexplorerobject"
  message("Done.")
  return(loaded_data)
}

# Method for character  ---------------------------------------------------

#' Method for preparing character vector for exploration
#'
#' @rdname prepare_data
#' @param dataset Object to convert to corporaexplorerobject:
#'   \itemize{
#'   \item A data frame with a specified column containing text (default column name: "Text") (class
#'   character), and optionally other columns.
#'   If \code{date_based_corpus} is \code{TRUE} (the default),
#'   \code{dataset} must contain a column "Date" (of class Date).
#'   \item Or a non-empty character vector.
#' }
#' @param ... Other arguments to be passed to \code{prepare_data}.
#' @inheritParams prepare_data.data.frame
#' @export
#'
#' @details
#' A character vector will be converted to a simple corporaexplorerobject
#'   with no metadata.
#'
#' @examples
#'
#' ## From character vector
#' alphabet_corpus <- prepare_data(LETTERS)
#'
#' if(interactive()){
#' # Running exploration app:
#' explore(alphabet_corpus)
#' }
prepare_data.character <-
  function(dataset,
           corpus_name = NULL,
           use_matrix = TRUE,
           matrix_without_punctuation = TRUE,
           ...) {
    data <- tibble::tibble(Text = dataset)
    prepare_data.data.frame(
      data,
      FALSE,
      corpus_name = corpus_name,
      use_matrix = use_matrix,
      matrix_without_punctuation = matrix_without_punctuation,
      ...
    )
  }
