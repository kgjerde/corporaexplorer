#' Inserting html links and newlines in document for navigation
#'
#' Translated from Python. Slower, but fast enough.
#'
#' @param tekst Character string of length 1.
#' @param antall_deler Number of links to insert. Must correspond with the "tiles" argument in visualiser_dok().
#'
#' @return Document/character string with html anchors.
insert_doc_navigation_links <- function(tekst, antall_deler) {
    tekstlengde <- nchar(tekst)
    del_lengde <- tekstlengde %/% antall_deler + 1
    ny <- strsplit(tekst, "")[[1]]
    ny_2 = ""  # TODO
    i <- 1
    for (pos in seq(0, tekstlengde, del_lengde)) {
        ny_2[i] <- paste0(ny[(pos + 1):(pos + del_lengde)], collapse = "")
        i <- i + 1
    }
    ny_tekstlengde <- sum(nchar(ny_2))
    if (ny_tekstlengde > tekstlengde) {
        ny_2[length(ny_2)] <- substr(ny_2[length(ny_2)],
                                     1,
                                     (nchar(ny_2[length(ny_2)]) - (ny_tekstlengde - tekstlengde)))
    }
    if (length(ny_2) > antall_deler) {
        ny_2[antall_deler] <-
            paste0(ny[antall_deler:length(antall_deler)], collapse = "")
    } else if (length(ny_2) < antall_deler) {
        antall <- antall_deler - length(ny_2)
        ny_2 <- c(ny_2, rep("", antall))
    }
    ny <- paste0(
        sprintf(
            "<span class =\'posisjons_korrigering\' id=\'%s\'></span>",
            seq_len(antall_deler)
        ),
        ny_2
    )
    ny <- paste0(ny, collapse = "")
    ny <- stringr::str_replace_all(ny, "\n", "<br>")
    return(ny)
}
