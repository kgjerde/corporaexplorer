#' Displaying document with html anchors and term highlighting
#'
#' @param document Character string of length 1.
#' @param search_arguments reactiveValues object with search arguments.
#' @param chunks Number of html anchors to insert.
#'
#' @return Html coded character string
display_document <- function(document, search_arguments, my_colours = MY_COLOURS, chunks = 50) {
  vis_tekst <-
    insert_doc_navigation_links(document, chunks)

  patterns <- unique(search_arguments$terms_highlight)

  vis_tekst <- highlight_document(vis_tekst, patterns, MY_COLOURS, search_arguments$case_sensitive)

  return(vis_tekst)
}


#' Highlight terms in document
#'
#' @param text Character of length 1.
#' @param patterns regular expression
#' @param colours colour vector
#' @param markup by default <mark style="color:%s">\\1</mark>
#'
#' @return highlighted document
highlight_document <-
  function(text,
           patterns,
           colours,
           case_sensitive,
           markup = '<mark style="color:%s">\\1</mark>') {
    if (case_sensitive == FALSE) {
      ignoring_case <- TRUE
    } else if (case_sensitive == TRUE) {
      ignoring_case <- FALSE
    }
    
    for (i in seq_along(patterns)) {
      if (USE_ONLY_RE2R == TRUE) {
        text <-
          re2r::re2_replace_all(
            text,
            re2r::re2(paste0("(", patterns[i], ")"),
                      case_sensitive = case_sensitive),
            sprintf(markup,
                    colours[i])
          )[1]
      } else if (USE_ONLY_RE2R == FALSE) {
        text <-
          stringr::str_replace_all(
            text,
            stringr::regex(paste0("(", patterns[i], ")"),
                           ignore_case = ignoring_case),
            sprintf(markup,
                    colours[i])
          )
      }
    }
    return(text)
  }
