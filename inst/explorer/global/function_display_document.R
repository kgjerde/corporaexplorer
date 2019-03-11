#' Displaying document with html anchors and term highlighting
#'
#' @param document Character string of length 1.
#' @param search_arguments reactiveValues object with search arguments.
#' @param chunks Number of html anchors to insert.
#'
#' @return Html coded character string
display_document <-
  function(document,
           search_arguments,
           my_colours = MY_COLOURS,
           chunks = DOCUMENT_TILES) {
    vis_tekst <-
      insert_doc_navigation_links(document, chunks)

    patterns <- unique(search_arguments$terms_highlight)

    vis_tekst <-
      highlight_document(vis_tekst,
                         patterns,
                         MY_COLOURS,
                         search_arguments$case_sensitive)

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

    doclength <- nchar(text)
    warning_text <- character(0)
    max_ratio <- 0.02

    for (i in seq_along(patterns)) {
      if (USE_ONLY_RE2R == TRUE) {
        hits <- re2r::re2_count(text,
                                re2r::re2(patterns[i],
                                          case_sensitive = case_sensitive))
        ratio <- hits / doclength

        if (ratio < max_ratio) {
          text <-
            re2r::re2_replace_all(
              text,
              re2r::re2(paste0("(", patterns[i], ")"),
                        case_sensitive = case_sensitive),
              sprintf(markup,
                      colours[i])
            )[1]
        } else {
          warning_text <- paste0(
            warning_text,
            sprintf(
              "<b>%s occurs too frequently to be higlighted</b><br>",
              patterns[i]
            )
          )
        }
      } else if (USE_ONLY_RE2R == FALSE) {
        hits <- stringr::str_count(text,
                                   stringr::regex(patterns[i],
                                                  ignore_case = ignoring_case))
        ratio <- hits / doclength

        if (ratio < max_ratio) {
          text <-
            stringr::str_replace_all(
              text,
              stringr::regex(paste0("(", patterns[i], ")"),
                             ignore_case = ignoring_case),
              sprintf(markup,
                      colours[i])
            )
        } else {
          warning_text <- paste0(
            warning_text,
            sprintf(
              "<b>%s occurs too frequently to be higlighted</b><br>",
              patterns[i]
            )
          )
        }
      }
    }

    if (length(warning_text) > 0) {
      warning_text <- paste0("<b>Warning:</b><br>",
                             warning_text,
                             "--------------------<br><br>")
      text <- paste0(warning_text, text)
    }

    return(text)
  }
