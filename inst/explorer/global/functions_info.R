create_df_for_info <- function(session_variables,
                               search_arguments,
                               modus) {
  if (modus == "data_dok") {
    start_df <- session_variables$data_dok
  } else if (modus == "data_365") {
    start_df <-
      filtrere_korpus_tid(
        .tibble = session_variables$data_dok,
        search_arguments = search_arguments,
        "data_dok"
      )

    if (search_arguments$subset_search == TRUE &
        nrow(start_df) != 0) {
      start_df <- filtrere_korpus_pattern(
        start_df,
        search_arguments,
        "data_dok"
      )
    }
  }

  if (info_terms_exist(search_arguments) == FALSE) {
    return(list(start_df = start_df))
  }

  cust_col <- search_arguments$custom_column
  length(cust_col) <- length(search_arguments$terms_highlight)
  tresh <- search_arguments$thresholds
  length(tresh) <- length(search_arguments$terms_highlight)

  reconstruct_full_terms <- function(term, optional1, optional2) {
    length(optional1) <- length(optional2) <- length(term)

    optional1[!is.na(optional1)] <- paste0("--", optional1[!is.na(optional1)])
    optional1[is.na(optional1)] <- ""

    optional2[!is.na(optional2)] <- paste0("--", optional2[!is.na(optional2)])
    optional2[is.na(optional2)] <- ""

    return(paste0(term, optional1, optional2))
  }

  full_terms <- reconstruct_full_terms(
    search_arguments$terms_highlight,
    search_arguments$custom_column,
    search_arguments$thresholds
  )

  # Checking distinctness
  distinkt <- which(!duplicated(full_terms))

  if (length(distinkt) != length(full_terms)) {
    full_terms <- full_terms[distinkt]
    tresh <- tresh[distinkt]
    cust_col <- cust_col[distinkt]
    terms <- search_arguments$terms_highlight[distinkt]
  } else {
    terms <- search_arguments$terms_highlight
  }

  Years <- start_df$Year

  if (nrow(start_df) != 0) {
    start_df <- count_search_terms_hits(
      start_df,
      search_arguments,
      loaded_data$original_matrix$data_dok,
      loaded_data$ordvektorer$data_dok,
      session_variables$data_dok,
      "data_dok",
      terms = terms
    )
  }

  colnames(start_df) <- full_terms

  return(list(
    start_df = start_df,
    full_terms = full_terms,
    tresh = tresh,
    cust_col = cust_col,
    terms = terms,
    years = Years
  ))
}

show_corpus_info_table <- function(search_arguments,
                                   session_variables,
                                   start_df_list) {
  start_df <- start_df_list$start_df
  full_terms <- start_df_list$full_terms
  tresh <- start_df_list$tresh
  cust_col <- start_df_list$cust_col
  terms <- start_df_list$terms

  df <- tidyr::gather(start_df) %>%
    dplyr::group_by(Term = key) %>%
    dplyr::summarise(
      Hits = as.integer(sum(value)),
      Documents = sum(value > 0),
      .groups = "drop_last"
    ) %>%
    dplyr::mutate(Threshold = plyr::mapvalues(
      Term,
      full_terms,
      tresh
    )) %>%
    dplyr::mutate(Column = plyr::mapvalues(
      Term,
      full_terms,
      cust_col
    )) %>%
    dplyr::mutate("Found in % of documents" = Documents / nrow(start_df) * 100) %>%
    dplyr::mutate("Hits per document" = Hits / nrow(start_df))

  df <- dplyr::select(df,
    Term,
    "Threshold?" = Threshold,
    "Custom column?" = Column,
    "Total hits" = Hits,
    "Found in no. of documents" = Documents,
    "Hits per document",
    "Found in % of documents"
  )

  if (all(is.na(df[["Threshold?"]]))) {
    df[["Threshold?"]] <- NULL
  }

  if (all(is.na(df[["Custom column?"]]))) {
    df[["Custom column?"]] <- NULL
  }

  df <- df[match(
    full_terms,
    df$Term
  ), ]

  df$Term <- terms

  return(df)
}

show_corpus_info_text <- function(search_arguments,
                                  session_variables,
                                  original_data_dok,
                                  start_df_list) {

  tekst <- text_about_original_corpus(original_data_dok)

  if (corpus_is_filtered(
    search_arguments,
    session_variables,
    original_data_dok
  )) {
    tekst <- paste0(
      tekst,
      text_about_filtered_corpus(
        session_variables,
        start_df_list
      )
    )
  }
  return(paste0(tekst, "<br>"))
}

text_about_original_corpus <- function(original_data_dok) {
  tekst <- sprintf(
    "<h4>General information</h4>The corpus contains %s document(s).<br>",
    format(nrow(original_data_dok), big.mark=",")
  )
  return(tekst)
}

corpus_is_filtered <-
  function(search_arguments,
             session_variables,
             original_data_dok) {
    return(search_arguments$subset_search |
      nrow(session_variables$data_dok) != nrow(original_data_dok) |
      sum(session_variables$data_365$Invisible_fake_date) != sum(loaded_data$original_data$data_365$Invisible_fake_date))
  }

text_about_filtered_corpus <-
  function(session_variables,
             start_df_list) {
    start_df <- start_df_list$start_df

    documents <- nrow(start_df)

    sprintf(
      "The filtered corpus contains %s document(s).",
      format(documents, big.mark = ",")
    )
  }

info_terms_exist <- function(search_arguments, info_mode = "regular") {
  if (info_mode == "regular") {
    return(length(search_arguments$terms_highlight) != 0)
  } else if (info_mode == "extra") {
    return(length(search_arguments$extra_chart_terms) != 0)
  }
}


pastebr <- function(...) {
  return(paste(..., sep = "<br>"))
}

#' Creates plot in corpus info tab
#'
#' @return A ggplot2 plot object.
corpus_info_plot <- function(start_df_list, search_arguments, info_mode) {
  if (info_terms_exist(search_arguments, info_mode)) {

    start_df <- start_df_list$start_df
    full_terms <- colnames(start_df)

    years <- start_df_list$years

    if (!is.numeric(years)) {
      years <- as.numeric(factor(years, levels = unique(years)))
    }

    df <- cbind(start_df, Year = years)

    df <- tidyr::gather(df, "Term", value = "Count", -Year)

    fig_tib <- df %>%
      dplyr::group_by(Year, Term) %>%
      dplyr::summarise(Count = as.integer(sum(Count)), .groups = "drop_last")

    fig_tib$Term <- factor(fig_tib$Term, levels = full_terms)

    # In case of "missing years"
    if (length(unique(fig_tib$Year)) > 1) {
    fig_tib <-
      padr::pad_int(dplyr::ungroup(fig_tib), by = "Year", group = "Term") %>%
      padr::fill_by_value(Count, value = 0)
    }

    info_plot <- ggplot2::ggplot(data = fig_tib)
    if (length(unique(fig_tib$Year)) == 1 | DATE_BASED_CORPUS == FALSE) {
      info_plot <-
        info_plot + ggplot2::geom_col(ggplot2::aes(x = Year, y = Count, fill = Term), position = "dodge") +
        ggplot2::scale_fill_manual(values = MY_COLOURS)
    } else {
      info_plot <-
        info_plot + ggplot2::geom_line(ggplot2::aes(x = Year, y = Count, color = Term)) + ggplot2::scale_color_manual(values = MY_COLOURS)
    }

    break_and_label_seq <- 1
# TODO: fine-tune axis labels
    info_plot <- info_plot + ggplot2::theme_classic() +
      ggplot2::scale_x_continuous(
        expand = c(0.01, 0),
        breaks = seq(
          from = min(fig_tib$Year),
          to = max(fig_tib$Year),
          by = break_and_label_seq
          ),
        labels = if (DATE_BASED_CORPUS == TRUE) {
          seq(min(fig_tib$Year),
              max(fig_tib$Year),
              by = break_and_label_seq)
        } else if (DATE_BASED_CORPUS == FALSE) {
          {stringr::str_sub(unique(start_df_list$years), 1, -1)[
            seq(min(fig_tib$Year),
              max(fig_tib$Year),
              by = break_and_label_seq)
            ]}
        }
      ) +
      ggplot2::scale_y_continuous(breaks = pretty(fig_tib$Count,
        n = 6,
        min.n = 1
      )) +
      ggplot2::labs(x = NULL, y = NULL) +
      ggplot2::theme(
        legend.title = ggplot2::element_blank(),
        legend.position = "top",
        legend.text = ggplot2::element_text(size=7)
      ) +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90,
                                                         vjust = 0.5,
                                                         hjust= 1,
                                                         size = 7),
                     axis.text.y = ggplot2::element_text(size = 7))
    info_plot
  } else {
    NULL
  }
}
