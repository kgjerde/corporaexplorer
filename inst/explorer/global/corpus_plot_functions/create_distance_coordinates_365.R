#' Determine distance between days in calendar view plot.
#'
#' @param test1 Df.
#' @param linjer Number of search term.
#' @param day_distance Between days.
#' @param month_distance Between months.
#' @param year_distance Between years.
#'
#' @return Adjusted df.
create_distance_coordinates_365 <- function(test1,
                                        linjer,
                                        day_distance,
                                        month_distance,
                                        year_distance
                                        ){
        
## AVSTAND MELLOM DAGER HORISONTALT
day_distance <- 0.3 * linjer
test1$x_min <- test1$x_min + (day_distance * test1$x_max)
test1$x_max <- test1$x_max + (day_distance * test1$x_max)

## AVSTAND MELLOM DAGER VERTIKALT
test1$y_min <- test1$y_min + (day_distance * test1$y_max) #test1$Weekday_n -1)
test1$y_max <- test1$y_max + (day_distance * test1$y_max) #test1$Weekday_n -1)

# Dette må til for ikke forskyvning og oppføkking ved > 1 søkeord. Men jeg forstår ikke helt.
for(i in seq_len(max(test1$df))){
test1$y_min[test1$df == i] <- test1$y_min[test1$df == i] - (day_distance * (i-1))
test1$y_max[test1$df == i] <- test1$y_max[test1$df == i] - (day_distance * (i-1))
}

## AVSTAND MELLOM MÅNEDER
month_distance <- 1
test1$x_min <- test1$x_min + (month_distance * test1$Month -1)
test1$x_max <- test1$x_max + (month_distance * test1$Month -1)

#AVSTAND MELLOM ÅR
year_distance<- 1.5
test1$y_min <- test1$y_min + (year_distance * test1$Year - min(test1$Year))
test1$y_max <- test1$y_max + (year_distance * test1$Year - min(test1$Year))

return(test1)
}
