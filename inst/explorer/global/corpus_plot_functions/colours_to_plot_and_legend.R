# TODO: denne er monstrøs

#' Transforming count factors to colours, and legend
#'
#' @param test1 Full data frame.
#' @param linjer Number of search terms.
#' @param number_of_factors Number of factors for each search term.
#'
#' @return List of length 2: 1) df with column Term_colour for colour of each document/day, 2) df for legend.
colours_to_plot_and_legend <- function(test1,
                                       linjer,
                                       number_of_factors = 8){

test1$Term_color <- test1$Term

len_1 <- test1$Term %>%
    stringr::str_subset("^1") %>%
    unique %>%
    length

len_2 <- test1$Term %>%
    stringr::str_subset("^2") %>%
    unique %>%
    length

len_3 <- test1$Term %>%
    stringr::str_subset("^3") %>%
    unique %>%
    length    

farger_1 <- character(0)
farger_2 <- character(0)
farger_3 <- character(0)

# Jeg ønsker spredning av fargene og å unngå de lyseste om mulig.
# Derfor ulike fargeutvalg avhengig av hvor mange faktorer.

if(number_of_factors == 8){
fargeutvalg_vektor <- list(
  9,
  c(5,9),
  c(3, 6, 9),
  c(3, 5, 7, 9),
  5:9,
  4:9,
  3:9,
  2:9
)
} else if(number_of_factors == 4){
  fargeutvalg_vektor <- list(
  4,
  c(4, 6),
  4:6,
  3:6
)
}

fra_vektor_1 <- tibble::tibble(
  original = unique(test1$Term_color[stringr::str_detect(test1$Term_color, "^1") & !is.na(test1$Term_color)]),
  for_sortering = original
  )

fra_vektor_1$for_sortering <- fra_vektor_1$for_sortering %>%
    stringr::str_replace("1-", "") %>%
    stringr::str_replace("-.*", "") %>%
    as.integer()

fra_vektor <- fra_vektor_1 %>%
    dplyr::arrange(for_sortering) %>%
    .$original

if(nrow(fra_vektor_1) != 0) {

farger_1 <- RColorBrewer::brewer.pal(name = "Reds", 9)[fargeutvalg_vektor[[len_1]]]


test1$Term_color[stringr::str_detect(test1$Term_color, "^1") & !is.na(test1$Term_color)] <-
    plyr::mapvalues(x = test1$Term_color[stringr::str_detect(test1$Term_color, "^1") & !is.na(test1$Term_color)],
                    from = fra_vektor,
                    to = farger_1
                    )
}

if(linjer == 2){
fra_vektor_2 <- tibble::tibble(
  original = unique(test1$Term_color[stringr::str_detect(test1$Term_color, "^2") & !is.na(test1$Term_color)]),
  for_sortering = original
  )

fra_vektor_2$for_sortering <- fra_vektor_2$for_sortering %>%
    stringr::str_replace("2-", "") %>%
    stringr::str_replace("-.*", "") %>%
    as.integer()

fra_vektor <- fra_vektor_2 %>%
    dplyr::arrange(for_sortering) %>%
    .$original

if(nrow(fra_vektor_2) != 0) {
  
farger_2 <- RColorBrewer::brewer.pal(name = "Blues", 9)[fargeutvalg_vektor[[len_2]]]
  
test1$Term_color[stringr::str_detect(test1$Term_color, "^2") & !is.na(test1$Term_color)] <-
    plyr::mapvalues(x = test1$Term_color[stringr::str_detect(test1$Term_color, "^2") & !is.na(test1$Term_color)],
                    from = fra_vektor,
                    to = farger_2
                    )
}
til_legend <- rbind(
  dplyr::arrange(fra_vektor_1, for_sortering),
  dplyr::arrange(fra_vektor_2, for_sortering)) %>%
  dplyr::mutate(fargekoder = c(farger_1, farger_2)) %>%
  dplyr::mutate(original = stringr::str_replace(original, "^\\d-", ""))

}


if(linjer == 1){
  
  til_legend <- 
  dplyr::arrange(fra_vektor_1, for_sortering) %>%
  dplyr::mutate(fargekoder = farger_1) %>%
  dplyr::mutate(original = stringr::str_replace(original, "^\\d-", ""))

}

return(list(test1, til_legend))
}
