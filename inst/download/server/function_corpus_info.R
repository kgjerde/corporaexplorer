corpus_info_text <- function() {
    terms_highlight <- search_arguments$highlight_terms

    tekst <- sprintf("The corpus contains %s documents.",
                     format(nrow(abc), big.mark=","))

    if (nrow(sv$subset) != nrow(abc)) {
        tekst <- paste(sep = "<br>",
                       tekst,
                       sprintf(
                           "The filtered corpus contains %s documents.",
                           format(nrow(sv$subset), big.mark = ",")
                       ))
    }

    if (highlight_terms_exist()) {
        tekst <- paste0(tekst, "<br>")

        for (i in seq_along(terms_highlight)) {
            term <- terms_highlight[i]

            term_count <- stringr::str_count(sv$subset$Text, stringr::regex(term,
                                                                     ignore_case = !search_arguments$case_sensitive))
            treff <- sum(term_count)
            docs <- length(term_count[term_count > 0])

            tekst <- paste(
                sep = "<br>",
                tekst,
                sprintf(
                    "%s is found a total of %s times in %s documents.",
                    term,
                    format(treff, big.mark=","),
                    format(docs, big.mark=",")
                )
            )
        }
    }
    return(tekst)
}
