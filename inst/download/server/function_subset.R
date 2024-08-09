

# subset_year <- function(.tibble, year_1, year_2) {
#     filtrert_tibble <- .tibble[.tibble$Year %in% year_1:year_2,]
#     return(filtrert_tibble)
# }

subset_date <- function(.tibble, date_1, date_2) {
    filtrert_tibble <- .tibble[.tibble$Date >= date_1 & .tibble$Date <= date_2,]
    return(filtrert_tibble)
}

# Filtrering ved filter-pattern hvis et slikt finnes
# subset_terms <- function(.tibble, terms) {
#     if (!is.null(terms)) {
#         for (i in seq_along(terms)) {
#             .tibble <-
#                 dplyr::filter(.tibble,
#                               stringr::str_detect(
#                                   Text,
#                                   stringr::regex(
#                                       terms[i],
#                                       ignore_case = !search_arguments$case_sensitive
#                                   )
#                               ))
#         }
#     }
#     return(.tibble)
# }

subset_terms <- function(.tibble, terms, threshold, custom_column) {
    if (!is.null(terms)) {
        for (i in seq_along(terms)) {
            if (!is.na(custom_column[i])) {
                text_column <-
                    rlang::sym(custom_column[i])
            } else {
                text_column <- rlang::sym("Text")
            }

            if (is.na(threshold[i])) {
                threshold[i] <- 1
            }

            .tibble <- .tibble %>%
                dplyr::mutate(hitcount =
                                  stringr::str_count(
                                      !!text_column,
                                      stringr::regex(
                                          terms[i],
                                          ignore_case = !search_arguments$case_sensitive
                                      )
                                  )) %>%
                dplyr::filter(hitcount >= threshold[i])
        }
    }
    return(.tibble)
}


