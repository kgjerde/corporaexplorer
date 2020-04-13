# "Day corpus" -- creation and styling (only in data_365)
data_day <-
  session_variables$data_dok[which(session_variables$data_dok$Date == session_variables[[plot_mode$mode]]$Date[min_rad]),]

if ("Title" %in% colnames(data_day)) {
  data_day$Title_2 <-
    paste(seq_len(nrow(data_day)), data_day$Title)

  if (search_arguments$case_sensitive == FALSE) {
    text_column <- data_day$Text
  } else if (search_arguments$case_sensitive == TRUE) {
    text_column <- data_day$Text_original_case
  }

  if (USE_ONLY_RE2R == TRUE) {
    # count_function <- re2r::re2_count
  } else if (USE_ONLY_RE2R == FALSE) {
    count_function <- stringr::str_count
  }

  if (identical(search_arguments$search_terms, "") == FALSE) {
    data_day$Termer <-
      count_function(text_column,
                     paste(search_arguments$search_terms,
                           collapse = "|"))

    # Grayer title in title list when no hits
    data_day$Title_2[data_day$Termer == 0] <-
      paste0("<span style='color:gray;'>",
             data_day$Title_2[data_day$Termer == 0],
             "</span>")

    # Jeg trodde dette skulle være redundant, men av og til var alle grå (selv uten grå html-kode)
    data_day$Title_2[data_day$Termer > 0] <-
      paste0("<span style='color:black;'>",
             data_day$Title_2[data_day$Termer > 0],
             "</span>")
  }
}
