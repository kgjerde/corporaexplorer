# TODO: see commit 77764f92db0418eb0558cbc0f10683dc77b11981 must be done again
#' Creating coordinates for corpus plot in document brick wall view or single day view
#'
#' @param df Data frame including factors for each document according to
#'   search term count (from create_factors_for_labelling ()).
#'
#' @return Full data_dok df or day df with additional columns determining plot coordinates
#'   for each document.
create_coordinates_1_data_dok <- function(df, linjer, max_width_for_row = NULL) {

if(is.null(max_width_for_row)){
max_width_for_row <- sqrt(sum(df$Tile_length) /  linjer)  # TODO: width-algoritmer
}

max_width_for_row <- MAX_WIDTH_FOR_ROW

# df$x_min <- NA
df$x_max <- cumsum(df$Tile_length)

# Betydelig speed-up
df$x_min <- dplyr::lag(df$x_max, default = 0)

# New algorithm for wall view plot.
# New row when:
# * max_width_for_row is exceeded
# * or when year/category changes
# :

Tile_length <- df$Tile_length
Year <- df$Year
last_tile_in_row <- integer(0)
current_width <- Tile_length[1]

if (nrow(df) > 1) {
    for (i in 2:nrow(df)) {
        if ((current_width + Tile_length[i]) > max_width_for_row |
            Year[i] != Year[i - 1]) {
            current_width <- Tile_length[i]
            last_tile_in_row <- c(last_tile_in_row, i - 1)
        } else {
            current_width <- current_width + Tile_length[i]
        }
    }
}

y_min <- integer(nrow(df))
y_min[y_min == 0] <- NA
if (nrow(df) > 1) {
    y_min[last_tile_in_row] <- seq_along(last_tile_in_row)
}
y_min <- zoo::na.locf(y_min, fromLast = TRUE, na.rm = FALSE)

y_min <-
    c(y_min, rep(max(y_min) + 1, nrow(df) - length(y_min)))

y_max <- y_min #*-1  # *-1 fordi reversed scale
y_min <- y_max - 1   # + 1 i stedet for -1 fordi reversed scale

df$y_min <- y_min
df$y_max <- y_max

## DATAFRAME FOR GGPLOT
test1 <- df %>%
    # Fordi x skal begynne på nytt hver rad:
    dplyr::group_by(y_max) %>%
    dplyr::mutate(x_min2 = x_min - min(x_min),
           x_max2 = x_max - min(x_min)) %>%
    dplyr::ungroup()

test1 <- dplyr::select(test1, -x_min, -x_max) %>%
    dplyr::rename(x_min = x_min2,
           x_max = x_max2)
return(test1)
}

