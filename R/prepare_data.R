# 1. "Regular" df: 1 doc = 1 row ------------------------------------------

#' Adjusts data frame to corporaexplorer format
#'
#' @param df Data frame with Date column (Date), Text column (character), and
#'   optionally Title (character), URL (character), and Type (character)
#'   columns.
#' @param tile_length_range Numeric vector of length two.
#'   Fine-tune the tile lengths in document wall
#'   and day corpus view. Tile length is calculated by
#'   \code{scales::rescale(nchar(dataset$Text),
#'   to = tile_length_range,
#'   from = c(0, max(.)))}
#'   Default is \code{c(1, 10)}.
#' @return A tibble ("data_dok")
#' @keywords internal
transform_regular <- function(df, tile_length_range = c(1, 10)) {
  message("Starting.")

  df <- dplyr::arrange(df, Date)

  df$Year <- lubridate::year(df$Date)

  df$Tile_length <- nchar(df$Text) %>%
    scales::rescale(to = tile_length_range, from = c(0, max(.)))

  df$ID <- seq_len(nrow(df))

  df$Text_original_case <- df$Text

  df$Text <-
    stringr::str_to_lower(df$Text) # for søke-purposes

  df <- dplyr::select(df,
                ID,
                Date,
                Text,
                Text_original_case,
                Tile_length,
                Year,
                sort(colnames(df)[!colnames(df) %in% c("ID",
                                                               "Date",
                                                               "Text",
                                                               "Text_original_case",
                                                               "Tile_length",
                                                               "Year")]))

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
    dplyr::mutate(Text = "Date with document in original df")

  min_date <- min(df_365$Date)
  max_date <- max(df_365$Date)

  df_365$Year <- lubridate::year(df_365$Date)

  df_365 <-
    padr::pad(df_365,
      interval = "day",
      start_val = as.Date(paste0(min(df_365$Year), "-01-01")),
      end_val = as.Date(paste0(max(df_365$Year), "-12-31"))
    )

  df_365$Day_without_docs <- is.na(df_365$Text)

  df_365$Text <- NULL

  df_365$Day_without_docs[df_365$Day_without_docs == FALSE] <- NA

  df_365$Tile_length <- 1

  df_365$Year <- lubridate::year(df_365$Date)

  df_365$Weekday_n <- lubridate::wday(df_365$Date, week_start = 1)

  df_365$Month_n <- lubridate::month(df_365$Date)

  df_365$Yearday_n <- lubridate::yday(df_365$Date)

  df_365 <-
    dplyr::arrange(df_365, Year, Weekday_n, Yearday_n, Month_n)

  df_365$Invisible_fake_date <- FALSE

  df_365$Invisible_fake_date[df_365$Date < min_date | df_365$Date > max_date] <- TRUE

  df_365_month_dividers <- df_365 %>%
    dplyr::group_by(Year) %>%
    dplyr::slice(1) %>%
    dplyr::mutate(Diff = Yearday_n - Weekday_n) %>%
    dplyr::filter(Diff > 0) %>%
    dplyr::mutate(Diff = 7 - Diff)

  if (nrow(df_365_month_dividers) != 0) {
    df_365_month_dividers_for_df <- tibble::tibble()
    for (row in seq_len(nrow(df_365_month_dividers))) {
      temp_tib <- tibble::tibble(
        Date = as.Date("8000-01-01"),
        Year = df_365_month_dividers$Year[row],
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
    dplyr::arrange(df_365, Year, Weekday_n, Yearday_n, Month_n)

  df_365$ID <- seq_len(nrow(df_365))

  df_365 <- dplyr::select(df_365,
                          ID,
                          Date,
                          Year,
                          Weekday_n,
                          Day_without_docs,
                          Invisible_fake_date,
                          Tile_length
                          )

  message("Calendar data frame done.")
  return(df_365)
}

# 3. Chr vector to til 'matrix'/data.table for faster search --------------

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
#' This should not be a problem for the vast opportunity of use cases, but if
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
  df <- dplyr::select(df, Text, ID)

  if (matrix_without_punctuation == TRUE) {
    df$Text <- df$Text %>%
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

  df$Text <- df$Text %>%
    stringr::str_replace_all("\\s", " ") %>%
    stringr::str_replace_all(" {2,}", " ") %>%
    stringr::str_trim()

  message("Document term matrix: text processed.")

  data.table::setDT(df)
  df <-
    df[, list(word = unlist(stringi::stri_split_fixed(Text, pattern = " "))),
      by =
        ID
    ][,
      list(count = .N),
      by = c("ID", "word")
    ][order(ID, word), ]

  message("Document term matrix: tokenising completed.")

  ord <- unique(df$word) %>% sort()

  message("Document term matrix: word list created.")

  df$word <-
    plyr::mapvalues(df$word, ord, seq_along(ord)) %>%
    as.integer()

  df <- dplyr::select(df, ID, word, count)

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
#'   \code{\link[corporaexplorer]{explore}} and
#'   \code{\link[corporaexplorer]{run_document_extractor}}.
#' @export
prepare_data <- function(dataset, ...) {
   UseMethod("prepare_data")
 }

# Method for data.frame ---------------------------------------------------

#' @export
#' @rdname prepare_data
#' @param dataset Object to be converted to a corporaexplorerobject.
#'   Converts a data frame with a column "Text" (class
#'   character), and optionally other columns.
#'   If \code{date_based_corpus} is \code{TRUE} (the default),
#'   \code{dataset} must contain a column "Date" (of class Date).
#' @param date_based_corpus Logical. Set to \code{FALSE} if the corpus
#'   is not to be organised according to document dates.
#' @param grouping_variable Character string.
#'   If \code{date_based_corpus} is \code{TRUE}, this argument is ignored.
#'   If \code{date_based_corpus} is \code{FALSE}, this argument can be used
#'   to group the documents, e.g. if \code{dataset} is organised by chapters
#'   belonging to different books.
#' @param within_group_identifier Character string indicating column name in \code{dataset}.
#'  \code{"Seq"}, the default, means the rows in each group are assigned
#'  a numeric sequence 1:n where n is the number of rows in the group.
#'  Used in document tab title in non-date based corpora.
#'  If \code{date_based_corpus} is \code{TRUE}, this argument is ignored.
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
#' @details For data.frame: Each row in \code{dataset} is treated as a base differentiating unit in the corpus,
#'   typically chapters in books, or a single document in document collections.
#'   The following column names are reserved and cannot be used in \code{dataset}:
#'   "ID",
#'   "Text_original_case",
#'   "Tile_length",
#'   "Year",
#'   "Seq",
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
#'
#' # Running app to extract documents:
#' run_document_extractor(corpus)
#' }
prepare_data.data.frame <- function(dataset,
                         date_based_corpus = TRUE,
                         grouping_variable = NULL,
                         within_group_identifier = "Seq",
                         columns_doc_info = c("Date", "Title", "URL"),
                         corpus_name = NULL,
                         use_matrix = TRUE,
                         matrix_without_punctuation = TRUE,
                         tile_length_range = c(1, 10),
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

  if ("Text" %in% colnames(dataset) == FALSE) {
    stop("Hmm. Make sure that 'dataset' contains a 'Text' column.",
      call. = FALSE
    )
  }

  if (anyNA(dataset$Text)) {
    stop("Hmm. Make sure that 'dataset$Text' does not contain any NA values.",
      call. = FALSE
    )
  }

  if (!is.character(dataset$Text)) {
    stop("Hmm. Make sure that 'dataset$Text' is a character vector.",
      call. = FALSE
    )
  }

  if (nrow(dataset) == 0) {
    stop("Hmm. corporaexplorer cannot explore an empty corpus. ",
         "Please check 'dataset'.",
      call. = FALSE
    )
  }

  RESERVED_NAMES <- c("ID",
                      "Text_original_case",
                      "Tile_length",
                      "Year",
                      "Seq",
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

    if ("Date" %in% colnames(dataset) == TRUE) {
      stop("If 'date_based_corpus' == FALSE, 'dataset' is not allowed to contain a 'Date' column.",
        call. = FALSE)
    }

    if (!is.null(grouping_variable)) {
      if (grouping_variable %in% colnames(dataset) == FALSE) {
        stop("'grouping_variable' has to be a column in 'dataset'.",
          call. = FALSE)
      }
    }

  }

# Pre-preparing non_date_based_corpus -------------------------------------

  if (date_based_corpus == FALSE) {
    # 'Date' placeholder
    dataset$Date <- as.Date("1882-09-05")

  }

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
    abc$Date <- NULL

    if (!is.null(grouping_variable)) {
      abc$Year <- dataset[[grouping_variable]]
    } else {
      abc$Year <- " "
    }

    if (within_group_identifier %in% c("Seq", colnames(dataset)) == FALSE) {
      stop("'within_group_identifier' must be a column in 'dataset'.",
        call. = FALSE)
    }

    if (within_group_identifier == "Seq") {
      abc <- abc %>%
        dplyr::group_by(Year) %>%
        dplyr::mutate(Seq = 1:dplyr::n())
    } else {
      abc$Seq <- abc[[within_group_identifier]]
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

  # For config constants
  loaded_data$date_based_corpus <- date_based_corpus
  loaded_data$original_data$grouping_variable <- grouping_variable

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
#'   \item A data frame with a column "Text" (class
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
