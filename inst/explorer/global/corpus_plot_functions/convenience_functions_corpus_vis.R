## Adapted from
# https://stackoverflow.com/questions/2776135/last-observation-carried-forward-in-a-data-frame/41752185#41752185
replace_NAs_with_next_or_previous_non_NA <- function(
  x,
  direction = c("previous", "next"),
  remove_na = FALSE
) {
  if (direction == "next") {
    x <- rev(x)
  }
  v <- !is.na(x)
  x <- c(NA, x[v])[cumsum(v) + 1]
  if (direction == "next") {
    x <- rev(x)
  }
  if (remove_na == TRUE) {
    x <- x[!is.na(x)]
  }
  return(x)
}
