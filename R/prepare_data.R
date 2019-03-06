# 1. “Regukar” df: 1 doc = 1 row ------------------------------------------

#' Adjusts data frame to corpusexploration format
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
  ## På grunn av non-breaking-spaces:
    new_df$Text <- gsub("\u00A0", " ", new_df$Text, fixed = TRUE)
    ## And "soft hyphens"
    new_df$Text <- gsub('\u00ad', "", new_df$Text, fixed = TRUE)
  }

  new_df$Year <- lubridate::year(new_df$Date)

  new_df$wc <- stringi::stri_count_words(new_df$Text) %>%
    scales::rescale(to = c(1, 10))

  new_df$id <- seq_len(nrow(new_df))

  new_df$Text_case <- new_df$Text

  new_df$Text <-
    stringr::str_to_lower(new_df$Text) # for søke-purposes
  message("1/3 Document data frame done.")
  return(new_df)
}



# 2. 365: 1 dag = 1 rute --------------------------------------------------

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


  katt <- new_df %>%
    dplyr::group_by(Date) %>%
    dplyr::summarise(Text = paste(Text_case, collapse = "\n\n--\n\n"))

  min_date <- min(katt$Date)

  katt$Year <- lubridate::year(katt$Date)

  katt <-
    padr::pad(katt, interval = "day", start_val = as.Date(paste0(min(katt$Year), "-01-01")))

  katt$empty <- is.na(katt$Text)
  # katt$empty[katt$empty == TRUE] <- "black"
  katt$empty[katt$empty == FALSE] <- NA

  katt$Text <- NULL

  katt$wc <- 1

  katt$Year <- lubridate::year(katt$Date)

  katt$Weekday_n <- lubridate::wday(katt$Date, week_start = 1)

  katt$Month_n <- lubridate::month(katt$Date)

  katt$Week_n <- lubridate::isoweek(katt$Date)

  katt$Yearday_n <- lubridate::yday(katt$Date)

  katt$No. <- 1:nrow(katt)

  kost <-
    dplyr::arrange(katt, Year, Weekday_n, Yearday_n, Month_n)
  kost$ID <- 1:nrow(kost)

  kost$mnd_vert <-
    kost$Month_n != dplyr::lead(kost$Month_n, default = FALSE)

  kost$mnd_hor <- is_last_in_month(kost$Date)

  kost$ID[kost$Date < min_date] <- 0

  kost2 <- kost %>%
    dplyr::group_by(Year) %>%
    dplyr::slice(1) %>%
    dplyr::mutate(Diff = Yearday_n - Weekday_n) %>%
    dplyr::filter(Diff > 0) %>%
    dplyr::mutate(Diff = 7 - Diff)

  tilleggs_tib <- tibble::tibble()
  for (row in seq_len(nrow(kost2))) {
    temp_tib <- tibble::tibble(
      No. = 0,
      Date = as.Date("1900-01-01"),
      Year = kost2$Year[row],
      Month_n = 1,
      Week_n = 1,
      Weekday_n = seq_len(kost2$Diff[row]),
      Yearday_n = sort(-seq_len(kost2$Diff[row]), decreasing = FALSE),
      ID = 0,
      empty = TRUE,
      wc = 1,
      mnd_vert = FALSE,
      mnd_hor = FALSE
    )
    tilleggs_tib <- rbind(tilleggs_tib, temp_tib)
  }

  tilleggs_tib <- dplyr::select(tilleggs_tib, colnames(kost))

  kost <- rbind(kost, tilleggs_tib) %>%
    dplyr::arrange(Year, Weekday_n, Yearday_n, Month_n)

  kost$id <- seq_len(nrow(kost))
  message("2/3 Calendar data frame done.")
  return(kost)
}

# 3. Text-vektor til matrix for faster search -----------------------------

#' Create document term matrix for fast search of single words
#'
#' The characters removed
#'
#' @param df A "data_dok" tibble
#' @param matrix_without_punctuation Should punctuation and digits be stripped
#'   from the text before constructing the document term matrix? If \code{TRUE},
#'   the default:
#' \itemize{
#'     \item The corpusexploration object will be lighter and most searches in
#'     the corpus exploration app will be faster.
#'     \item Searches including punctuation and digits will be carried out in
#'     the full text documents.
#'     \item The only "risk" with this strategy is that the corpus exploration
#'     app in some cases can produce false positives. E.g. searching for the
#'     term "donkey" will also find the term "don\%key".
#' This should not be a problem for the *vast* opportunity of use cases, but if
#' one so desires, there are three different solutions: set this paramater to
#' \code{FALSE}, create a corpusexplorationobject without a matrix by setting
#' the \code{use_matrix} parameter to \code{FALSE}, or run
#' \code{\link[corpusexplorationr]{run_corpus_explorer}} with the
#' \code{use_matrix} parameter set to \code{FALSE}.
#' }
#'  If \code{FALSE}, the corpusexploration object will be larger, and most
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
      stringr::str_replace_all('[\\Q!"#$%&\'()*+,/:;<=>?@[]^_`{|}~\u00ab\u00bb\u2026\\E]',
                               '') %>%
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
    df[, list(word = unlist(stringi::stri_split_fixed(Text, pattern = " "))), by =
         id][,
             list(count = .N), by = c('id', 'word')][order(id, word), ]

  message("3/3 Document term matrix: tokenising completed.")

  ord <- unique(df$word) %>% sort

  message("3/3 Document term matrix: word list created.")

  df$word <-
    plyr::mapvalues(df$word, ord, seq_along(ord)) %>% as.integer

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


# 4. Eksempel på fullverdig prosedyre ----------------------------------------

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
#'   more memory. If \code{FALSE}, the returning corpusexplorationobject will be more light-weight, but
#'   searching will be slower.
#' @inheritParams transform_regular
#' @inheritParams matrix_via_r
#' @return A \code{corpusexploration} object to be passed as argument to
#'   \code{\link[corpusexplorationr]{run_corpus_explorer}} and
#'   \code{\link[corpusexplorationr]{run_download_tool}}.
#' @export
#' @examples
#' # Constructing test data frame:
#' dates <- as.Date(paste(2011:2020, 1:10, 21:30, sep = "-"))
#' texts <- paste0("This is a document about ", month.name[1:10], ". ",
#'    "This is not a document about ", rev(month.name[1:10]), ".")
#' titles <- paste("Text", 1:10)
#' test_df <- data.frame(Date = dates, Text = texts, Title = titles)
#'
#' # Converting to corpusexploration object:
#' corpus <- prepare_data(test_df, corpus_name = "Test corpus")
#'
#' \dontrun{
#' # Running exploration app:
#' run_corpus_exploration(corpus)
#'
#' # Running download app:
#' run_download_tool(corpus)
#' # Or:
#' run_download_tool(test_df)
#' }
prepare_data <- function(dataset,
                         columns_to_include = NULL,
                         columns_doc_info = c("Date", "Title", "URL"),
                         corpus_name = NULL,
                         use_matrix = TRUE,
                         normalise = TRUE,
                         matrix_without_punctuation = TRUE) {

  abc <- transform_regular(dataset,
                           columns_to_include,
                           normalise)

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

  # 5. Lagring og innlasting av de fire filene som trengs ------------------------------------

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
      message(sprintf("Column %s does not exist and is ignored.",
                      missing_columns[i]))
    }
  }

  class(loaded_data) <- "corpusexplorationobject"
  message("Done.")
  return(loaded_data)
}
