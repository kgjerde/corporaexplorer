#' Custom, faster replacement for padr::padint()
#'
#' @return Data_365 df padded with rows for days without documents
min_padding <- function(frekvensmatrix, original_tibble){
# Full vektor -- alle dokumenter
    # full_vector <- seq_len(max(summ$i))
    full_vector <- original_tibble$cx_ID # MYE raskere å telle rader i text-tibble enn å søke etter maks dok-verdi i matrixen

    # Dokumenter med .pattern
    doc_vector <- unique(frekvensmatrix$i)

    # Garderer meg mot ingen treff, fordi da blir det rar oppførsel:
    if (length(doc_vector) == 0) {
        manglende_vector <- full_vector
    } else {
        # = "manglende" dokumenter (altså de uten .pattern)
        manglende_vector <- full_vector[!(full_vector %in% doc_vector)]
    }

    # Lager tibble med value = 0 for de "innpaddede"
    manglende_vector <- tibble::tibble(i = manglende_vector, total = 0)

    # Sette dem sammem og sorter
    rbind(frekvensmatrix, manglende_vector) %>%
        dplyr::arrange(i)
}

#' Filtering column with search_term_count for threshold
#'
#' Applied only when threshold in search.
#'
#' @return Filtered df
filter_by_count_argument <- function(df, pattern, count_argument) {
    df[pattern][df[pattern] < count_argument] <- 0
    return(df)
}

#' Check if whitespace in pattern
#'
#' Why: If whitespace, matrix will not be used.
#'
#' @return Logical.
contains_whitespace <- function(pattern) {
    return(length(stringr::str_split(pattern, "\\s|\\\\s", simplify = TRUE)) != 1)
}

#' Check for regex word boundary
#'
#' Why: re2 does not recognize non-ASCII word boundaries.
#'
#' @return Logical.
contains_regex_word_boundary <- function(pattern) {
# Fordi re2 ikke gjenkjenner ikke-ASCII word boundaries:
# http://qinwenfeng.com/re2r_doc/re2r-syntax.html#empty_strings
    return(stringr::str_detect(pattern, "\\\\[BbWw]"))
}

#' Checks for regex special characters
#'
#' Rationale: make stringr take almost all complex searches
#' @param pattern
#'
#' @return Logical
contains_other_regex_special_characters <- function(pattern) {
    stringr::str_detect(pattern,
                        "[\\[\\]\\(\\)\\{\\}]") |
        stringr::str_detect(pattern,
                            "\\\\[^BbWwSs]")
}

#' Check if punctuation in pattern
#'
#' Why: If yes, matrix will not be used.
#'
#' @return Logical.
contains_punctuation_or_digit <- function(pattern) {
    if (MATRIX_WITHOUT_PUNCTUATION == FALSE) {
        return(FALSE)
    }
    return(stringr::str_detect(pattern, PUNCTUATION_REGEX))
}


#' Check if pattern is ASCII characters only
#'
#' Why: re2 related. If no, check for word boundaries character.
#'
#' @return Logical.
is_ascii <- function(pattern) {
    return(stringi::stri_enc_mark(pattern) == "ASCII")
}

#' Combines checks to decide if matrix search can be used.
#'
#' @return Logical.
can_use_matrix <-
    function(pattern,
             subset_search,
             case_sensitive,
             custom_column) {
        if (case_sensitive == TRUE |
            NO_MATRIX == TRUE | !is.na(custom_column)) {
            return(FALSE)
        } else {
            return (
                contains_whitespace(pattern) == FALSE &
                    contains_punctuation_or_digit(pattern) == FALSE
            )
        }
    }

#' Combines checks to decide if re2 can be used.
#'
#' @return Logical.
can_use_re2 <- function(pattern) {
    if (USE_ONLY_STRINGR == TRUE) {
        return(FALSE)
    } else if (USE_ONLY_RE2 == TRUE) {
        return(TRUE)
    }
    if (contains_other_regex_special_characters(pattern)) {
        return(FALSE)
    }
    # Fordi re2 ikke håmdterer ikke-ascii word boundaries(f.eks. "\\bнато)
    if (contains_regex_word_boundary(pattern) == FALSE) {
        return(TRUE)
    } else if (is_ascii(pattern) == FALSE) {
        return(FALSE)
    } else {
        return(TRUE)
    }
}

#' Main matrix search function
#'
#' @return Df with column with search_term count for each document.
count_matrix <- function(pattern, matriks, df, ordvektor) {
    if (can_use_re2(pattern)) {
        regex_detect <- re2::re2_detect
                # print("re2")
    } else {
        regex_detect <- stringr::str_detect
                # print("str")
    }

    ord_indekser <- which(regex_detect(ordvektor,
                                           pattern))
    ## Lager data.table med bare dokumentene som inneholder ordene og total count
    #
    treff_count_matrix <- matriks[j %in% ord_indekser] %>%
        .[i %in% df$cx_ID] %>%  # bare nødvendig ved subset-filtrering, men koster lite
        dplyr::group_by(i) %>%
        dplyr::summarise(total = sum(x), .groups = "drop_last")
    ## Padder, slik at vi får tibble med alle dokumentene, treff = 0 for de "innpaddede"
    #
    treff_count_matrix <-
        min_padding(treff_count_matrix, df)
    ## Trekker ut kun treff_count-kolonnen
    #
    treff_count_matrix <- tibble::tibble(treff_count_matrix$total)
    return(treff_count_matrix)
}

#' Main data frame (text) search function
#'
#' @return Df with column with search_term count for each document.
count_df <- function(pattern, df, case_sensitive, custom_column) {

    re2_ok <- can_use_re2(pattern)

    if (re2_ok == TRUE) {
        regex_count <- re2::re2_count
        # print("re2")
    } else {
        regex_count <- stringr::str_count
        # print("str")
    }

    regex_or_fixed <- stringr::regex

    if (case_sensitive == FALSE) {
        text_column <- df$Text_column_
    } else if (case_sensitive == TRUE) {
        text_column <- df$Text_original_case
    }

    if (!is.na(custom_column)) {
        if (re2_ok == TRUE) {
            treff_count_matrix <-
                tibble::tibble(re2::re2_count(
                    df[[custom_column]],
                    re2::re2_regexp(pattern, case_sensitive = case_sensitive)
                ))
            return(treff_count_matrix)
        } else if (re2_ok == FALSE) {
            treff_count_matrix <-
                tibble::tibble(stringr::str_count(
                    df[[custom_column]],
                    stringr::regex(pattern, ignore_case = !case_sensitive)
                ))
            return(treff_count_matrix)
        }
    }

    treff_count_matrix <-
                tibble::tibble(regex_count(text_column,  # korpus_365$Text
                                    regex_or_fixed(pattern)))
    return(treff_count_matrix)
}


#' Main function for counting search_term frequency in corpus
#'
#' @param pattern Character vector of length 1.
#' @param matriks As in visualiser_korpus().
#' @param df As df in visualiser_korpus().
#' @param ordvektor As in visualiser_korpus().
#' @param subset_search search_arguments$subset_search.
#' @param case_sensitive search_arguments$case_sensitive.
#' @param thresholds search_arguments$thresholds.
#' @param doc_df As in visualiser_korpus().
#' @param modus As in visualiser_korpus().
#'
#' @return Df with 1 column, column name == pattern.
count_hits_for_each_search_term <-
    function(pattern,
             matriks,
             df,
             ordvektor,
             subset_search,
             case_sensitive,
             thresholds,
             doc_df,
             modus,
             custom_column) {
        if (modus == "data_365") {
            dataframe <- doc_df
        } else {
            dataframe <- df
        }

        if (can_use_matrix(pattern, subset_search, case_sensitive, custom_column)) {
            df_count <- count_matrix(pattern, matriks, dataframe, ordvektor)
            # print("matr")
        } else {
            df_count <- count_df(pattern, dataframe, case_sensitive, custom_column)
            # print("df")
        }

        colnames(df_count) <- pattern

        if (!is.na(thresholds)) {
            df_count <-
                filter_by_count_argument(df_count, pattern, thresholds)
        }

        # print(system.time({
        if (modus == "data_365") {
            df_count$Date <- doc_df$Date
            df_count <- df_count %>%
                dplyr::group_by(Date) %>%
                dplyr::summarise(treff = sum(!!rlang::sym(pattern)), .groups = "drop_last")
            df_count <- dplyr::left_join(df, df_count, by = "Date")
            df_count[["treff"]][is.na(df_count[["treff"]])] <- 0
            df_count <- dplyr::select(df_count, treff)
            colnames(df_count) <- pattern
        }
        # }))

        return(df_count)
    }
