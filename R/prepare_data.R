# 1. "Regular" df: 1 doc = 1 row ------------------------------------------

#' Adjusts data frame to corporaexplorer format
#'
#' @param df Data frame with Date column (Date), Text column (character), and
#'   optionally Title (character), URL (character), and Type (character)
#'   columns.
#' @param columns_to_include Character vector. The columns from df to be
#'   included in corpus object, in addition to the required Date and Text. E.g.
#'   \code{c("Title", "URL")}. If NULL, the default, all columns will be
#'   included.
#' @param normalise Should non-breaking spaces (U+00A0) and soft hyphens
#'   (U+00ad) be normalised?
#' @return A tibble ("data_dok")
#' @keywords internal
transform_regular <- function(df, columns_to_include = NULL, normalise = TRUE) {
  message("Starting.")

  if (is.null(columns_to_include)) {
    new_df <- df
  } else {
    new_df <-
      dplyr::select(df, Date, Text, columns_to_include) # Velg kolonner her.
  }

  if (normalise == TRUE) {
    for (i in seq_along(new_df)) {
      # Only for character columns
      if (is.character(new_df[[i]])) {
        ## På grunn av non-breaking-spaces:
        new_df[[i]] <- gsub("\u00A0", " ", new_df[[i]], fixed = TRUE)
        ## And "soft hyphens"
        new_df[[i]] <- gsub("\u00ad", "", new_df[[i]], fixed = TRUE)
      }
    }
  }

  new_df$Year <- lubridate::year(new_df$Date)

  new_df$wc <- nchar(new_df$Text) %>%
    scales::rescale(to = c(1, 10))

  new_df$id <- seq_len(nrow(new_df))

  new_df$Text_case <- new_df$Text

  new_df$Text <-
    stringr::str_to_lower(new_df$Text) # for søke-purposes
  message("1/3 Document data frame done.")
  return(new_df)
}



# 2. 365: 1 day = 1 tile --------------------------------------------------

#' Check if date is the last in the month
#'
#' @param date Date.
#'
#' @return Logical.
#' @keywords internal
is_last_in_month <- function(date) {
  check <- as.Date(date) + 1
  lubridate::month(check) != lubridate::month(date)
}

#' Convert "data_dok" tibble to "data_365" tibble
#'
#' @param new_df A "data_dok" tibble
#'
#' @return A "data_365" tibble.
#' @keywords internal
transform_365 <- function(new_df) {
  # @ new_df er en tibble klargjjort gjennom transform_regular()


  df_365 <- new_df %>%
    dplyr::group_by(Date) %>%
    dplyr::summarise(Text = paste(Text_case, collapse = "\n\n--\n\n"))

  min_date <- min(df_365$Date)
  max_date <- max(df_365$Date)

  df_365$Year <- lubridate::year(df_365$Date)

  df_365 <-
    padr::pad(df_365,
      interval = "day",
      start_val = as.Date(paste0(min(df_365$Year), "-01-01")),
      end_val = as.Date(paste0(max(df_365$Year), "-12-31"))
    )

  df_365$empty <- is.na(df_365$Text)
  # df_365$empty[df_365$empty == TRUE] <- "black"
  df_365$empty[df_365$empty == FALSE] <- NA

  df_365$Text <- NULL

  df_365$wc <- 1

  df_365$Year <- lubridate::year(df_365$Date)

  df_365$Weekday_n <- lubridate::wday(df_365$Date, week_start = 1)

  df_365$Month_n <- lubridate::month(df_365$Date)

  df_365$Week_n <- lubridate::isoweek(df_365$Date)

  df_365$Yearday_n <- lubridate::yday(df_365$Date)

  df_365$No. <- 1:nrow(df_365)

  df_365 <-
    dplyr::arrange(df_365, Year, Weekday_n, Yearday_n, Month_n)
  df_365$ID <- 1:nrow(df_365)

  df_365$mnd_vert <-
    df_365$Month_n != dplyr::lead(df_365$Month_n, default = FALSE)

  df_365$mnd_hor <- is_last_in_month(df_365$Date)

  df_365$ID[df_365$Date < min_date | df_365$Date > max_date] <- 0

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
        No. = 0,
        Date = as.Date("8000-01-01"),
        Year = df_365_month_dividers$Year[row],
        Month_n = 1,
        Week_n = 1,
        Weekday_n = seq_len(df_365_month_dividers$Diff[row]),
        Yearday_n = sort(-seq_len(df_365_month_dividers$Diff[row]), decreasing = FALSE),
        ID = 0,
        empty = TRUE,
        wc = 1,
        mnd_vert = FALSE,
        mnd_hor = FALSE
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

  df_365$id <- seq_len(nrow(df_365))

  message("2/3 Calendar data frame done.")
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
#' one so desires, there are three different solutions: set this paramater to
#' \code{FALSE}, create a corporaexplorerobject without a matrix by setting
#' the \code{use_matrix} parameter to \code{FALSE}, or run
#' \code{\link[corporaexplorer]{run_corpus_explorer}} with the
#' \code{use_matrix} parameter set to \code{FALSE}.
#' }
#'  If \code{FALSE}, the corporaexplorer object will be larger, and most
#'  simple searches will be slower.
#' @return List: 1) Document term matrix (data.table), 2) word vector (character
#'   vector).
#' @keywords internal
matrix_via_r <- function(df, matrix_without_punctuation = TRUE) {
  df <- dplyr::select(df, Text, id)

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

  message("3/3 Document term matrix: text processed.")

  data.table::setDT(df)
  df <-
    df[, list(word = unlist(stringi::stri_split_fixed(Text, pattern = " "))),
      by =
        id
    ][,
      list(count = .N),
      by = c("id", "word")
    ][order(id, word), ]

  message("3/3 Document term matrix: tokenising completed.")

  ord <- unique(df$word) %>% sort()

  message("3/3 Document term matrix: word list created.")

  df$word <-
    plyr::mapvalues(df$word, ord, seq_along(ord)) %>%
    as.integer()

  df <- dplyr::select(df, id, word, count)

  colnames(df) <- c("i", "j", "x")

  df <- data.table::as.data.table(df)

  ## Setter indeks/key på data.table for virkelig lynraskt søk!
  #
  data.table::setkey(df, j)
  data.table::setindex(df, i)

  message("3/3 Document term matrix done.")

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

#' Prepare data for corpus exploration
#'
#' @param dataset A data frame with Date column (class Date), Text column (class
#'   character), and optionally other columns, e.g. Title (class character) and URL
#'   (character).
#' @param columns_doc_info Character vector. The columns from df to display in
#'   the "document information" tab in the corpus exploration app. By default
#'   \code{Date}, \code{Title} and \code{URL} will be
#'   displayed, if included. If columns_doc_info includes a column which is not
#'   present in dataset, it will be ignored.
#' @param corpus_name Optional character string with name of corpus.
#' @param use_matrix Logical. Should the function create a document term matrix
#'   for fast searching? If \code{TRUE}, data preparation will run longer and demand
#'   more memory. If \code{FALSE}, the returning corporaexplorerobject will be more light-weight, but
#'   searching will be slower.
#' @inheritParams transform_regular
#' @inheritParams matrix_via_r
#' @return A \code{corporaexplorer} object to be passed as argument to
#'   \code{\link[corporaexplorer]{run_corpus_explorer}} and
#'   \code{\link[corporaexplorer]{run_document_extractor}}.
#' @export
#' @examples
#' # Constructing test data frame:
#' dates <- as.Date(paste(2011:2020, 1:10, 21:30, sep = "-"))
#' texts <- paste0(
#'   "This is a document about ", month.name[1:10], ". ",
#'   "This is not a document about ", rev(month.name[1:10]), "."
#' )
#' titles <- paste("Text", 1:10)
#' test_df <- tibble::tibble(Date = dates, Text = texts, Title = titles)
#'
#' # Converting to corporaexplorer object:
#' corpus <- prepare_data(test_df, corpus_name = "Test corpus")
#' \dontrun{
#' # Running exploration app:
#' run_corpus_explorer(corpus)
#'
#' # Running app to extract documents:
#' run_document_extractor(corpus)
#' }
prepare_data <- function(dataset,
                         columns_to_include = NULL,
                         columns_doc_info = c("Date", "Title", "URL"),
                         corpus_name = NULL,
                         use_matrix = TRUE,
                         normalise = TRUE,
                         matrix_without_punctuation = TRUE) {

  # Argument checking

  if (!all(is.logical(c(
    use_matrix,
    normalise,
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

  if (!is.null(columns_to_include)) {
    if (!all(columns_to_include %in% colnames(dataset))) {
      stop("Hmm. 'columns to include': Make sure to only specify column names present in 'dataset'.",
        call. = FALSE
      )
    }
  }

  if (!all(c("Date", "Text") %in% colnames(dataset))) {
    stop("Hmm. Make sure that 'dataset' contains 'Date' and 'Text' columns.",
      call. = FALSE
    )
  }

  if (lubridate::is.Date(dataset$Date) == FALSE) {
    stop("Hmm. Make sure that 'dataset$Date' is of class 'Date'.",
      call. = FALSE
    )
  }

  if (anyNA(dataset$Date)) {
    stop("Hmm. Make sure that 'dataset$Date' does not contain any NA values.",
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

  # The function proper

  abc <- transform_regular(
    dataset,
    columns_to_include,
    normalise
  )

  abc_365 <- transform_365(abc)

  if (use_matrix == TRUE) {
    matrix_list_dok <- matrix_via_r(abc, matrix_without_punctuation)
    matrix_dok <- get_matrix(matrix_list_dok)
    ordvektor_dok <- get_term_vector(matrix_list_dok)
    rm(matrix_list_dok)
  } else {
    matrix_dok <- FALSE
    ordvektor_dok <- FALSE
  }

  # 5. Putting the 'corporaexplorerobject' together ---------------------

  loaded_data <- list()

  loaded_data$original_data$data_dok <- abc
  loaded_data$original_data$data_365 <- abc_365

  loaded_data$original_matrix$data_dok <- matrix_dok
  loaded_data$ordvektorer$data_dok <- ordvektor_dok
  loaded_data$ordvektorer$without_punctuation <- matrix_without_punctuation

  loaded_data$name <- corpus_name
  loaded_data$columns_for_info <-
    columns_doc_info[columns_doc_info %in% colnames(abc)]

  if (any(!columns_doc_info %in% colnames(abc))) {
    missing_columns <-
      columns_doc_info[!columns_doc_info %in% colnames(abc)]
    for (i in seq_along(missing_columns)) {
      message(sprintf(
        "Column %s does not exist and is ignored.",
        missing_columns[i]
      ))
    }
  }

  class(loaded_data) <- "corporaexplorerobject"
  message("Done.")
  return(loaded_data)
}
