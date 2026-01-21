# Printing info about search method for each term -------------------------

termer <- c(search_arguments$terms_highlight, search_arguments$subset_terms)
kol <- c(search_arguments$custom_column, search_arguments$subset_custom_column)

for (i in seq_along(termer)) {
  message(sprintf(
    "%s: re2: %s; matrix: %s.",
    termer[i],
    can_use_re2(termer[i]),
    can_use_matrix(
      termer[i],
      search_arguments$subset_search,
      search_arguments$case_sensitive,
      kol[i]
    )
  ))
}
