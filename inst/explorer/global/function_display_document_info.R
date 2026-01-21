#' Display document info in doc info tab
#'
#' @param df session_variables$data_dok or session_variables$data_day
#' @param min_rad integer. row in df, i.e. document
#' @param info_columns Constant from config.R
#'
#' @return Character string
display_document_info <- function(df, min_rad, info_columns = INFO_COLUMNS) {
  doc_info_text <- ""

  if (DATE_BASED_CORPUS == TRUE) {
    doc_info_text <- paste(
      sep = "<br>",
      doc_info_text,
      paste0(
        tags$b("Date: "),
        format_date(df$Date[min_rad])
      )
    )
  }

  if ("Title" %in% info_columns) {
    doc_info_text <- paste(
      sep = "<br>",
      doc_info_text,
      paste0(tags$b("Title: "), df$Title[min_rad])
    )
  }

  if ("URL" %in% info_columns) {
    doc_info_text <- paste(
      sep = "<br>",
      doc_info_text,
      paste0(
        tags$b("URL: "),
        "<a href='",
        df$URL[min_rad],
        "' target='_blank'>",
        df$URL[min_rad],
        "</a>"
      )
    )
  }

  doc_info_text <- paste(
    doc_info_text,
    sep = "<br>",
    paste0(
      tags$b("Word count: "),
      stringi::stri_count_words(df$Text_column_[min_rad])
    )
  )

  other_columns <-
    info_columns[!info_columns %in% c("Date", "Title", "URL")]

  for (i in seq_along(other_columns)) {
    doc_info_text <- paste(
      doc_info_text,
      sep = "<br>",
      paste0(
        tags$b(other_columns[i]),
        tags$b(": "),
        df[[other_columns[i]]][min_rad]
      )
    )
  }

  # Trimming beginning of string
  return(stringr::str_replace(doc_info_text, "^<br>*", ""))
}
