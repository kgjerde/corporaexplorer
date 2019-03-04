corpus_info_text <- function() {
    terms_highlight <- search_arguments$highlight_terms

    tekst <- sprintf("The corpus contains %i documents.",
                     nrow(abc))
    
    if (nrow(sv$subset) != nrow(abc)) {
        tekst <- paste(sep = "<br>",
                       tekst,
                       sprintf(
                           "The filtered corpus contains %i documents.",
                           nrow(sv$subset)
                       ))
    }
    
    if (!identical(terms_highlight, "")) {
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
                    "%s is found a total of %i times in %i documents.",
                    term,
                    treff,
                    docs
                )
            )
        }
    }
    return(tekst)
}
