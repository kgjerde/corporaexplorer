#' Print friendly English date
#'
#' @param date date vector of length 1
#'
#' @return string of format "Friday 12 April 2019", regardless of locale.
format_date <- function(date) {
  WEEKDAYS <- c(
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  )
  weekday <- WEEKDAYS[lubridate::wday(date, week_start = 1)]
  day <- format(date, "%d")
  month <- month.name[as.integer(format(date, "%m"))]
  year <- format(date, "%Y")
  return(paste(
    weekday,
    day,
    month,
    year
  ))
}
