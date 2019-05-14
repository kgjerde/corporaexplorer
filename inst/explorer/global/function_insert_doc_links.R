#' Inserting html links and newlines in document for navigation
#'
#' Now inserting anchors only in spaces.
#' Should therefore be far fewer cases where word is not highlighted because
#' anchor breaks up pattern in text, causing it not to be found.
#' For the first search term, this should now not happen if search does
#' not contain spaces.
#'
#' @param text Character string of length 1.
#' @param antall_deler Number of links to insert. Must correspond with the "tiles" argument in visualiser_dok().
#'
#' @return Document/character string with html anchors.
insert_doc_navigation_links <- function(text, number_of_links) {
    # Counting
    number_of_spaces <- stringr::str_count(text, " ")
    # Insert only if not very short text
    if (number_of_spaces < number_of_links * 4) {
        return(text)
    }
    # Finding out where to insert
    index_for_anchors <- floor(seq(1, number_of_spaces, length.out = number_of_links))
    # Splitting
    ny <- stringr::str_split(text, " ")[[1]]
    # Inserting
    ny[index_for_anchors] <- paste0(sprintf("<span class=\'___\' id=\'%s\'></span>", seq_along(index_for_anchors)),
                                    ny[index_for_anchors])
    # Joining
    ny <- paste(ny, collapse = " ")
    return(ny)
}
