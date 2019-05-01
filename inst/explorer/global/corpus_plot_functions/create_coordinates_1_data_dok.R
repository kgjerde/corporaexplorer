# TODO: see commit 77764f92db0418eb0558cbc0f10683dc77b11981 must be done again
#' Creating coordinates for corpus plot in document brick wall view or single day view
#'
#' @param .data Data frame including factors for each document according to
#'   search term count (from create_factors_for_labelling ()).
#'
#' @return Full data_dok df or day df with additional columns determining plot coordinates
#'   for each document.
create_coordinates_1_data_dok <- function(.data, linjer, max_width_for_row = NULL) {

if(is.null(max_width_for_row)){
max_width_for_row <- sqrt(sum(.data$Tile_length) /  linjer)  # TODO: width-algoritmer
}

max_width_for_row <- MAX_WIDTH_FOR_ROW

# .data$x_min <- NA
.data$x_max <- cumsum(.data$Tile_length)

# Betydelig speed-up
.data$x_min <- dplyr::lag(.data$x_max, default = 0)

# New algorithm for wall view plot.
# New row when:
# * max_width_for_row is exceeded
# * or when year/category changes
# :

Tile_length <- .data$Tile_length
Year <- .data$Year
last_tile_in_row <- integer(0)
current_width <- Tile_length[1]

if (nrow(.data) > 1) {
    for (i in 2:nrow(.data)) {
        if ((current_width + Tile_length[i]) > max_width_for_row |
            Year[i] != Year[i - 1]) {
            current_width <- Tile_length[i]
            last_tile_in_row <- c(last_tile_in_row, i - 1)
        } else {
            current_width <- current_width + Tile_length[i]
        }
    }
}

y_min <- integer(nrow(.data))
y_min[y_min == 0] <- NA
if (nrow(.data) > 1) {
    y_min[last_tile_in_row] <- seq_along(last_tile_in_row)
}
y_min <- zoo::na.locf(y_min, fromLast = TRUE, na.rm = FALSE)

y_min <-
    c(y_min, rep(max(y_min) + 1, nrow(.data) - length(y_min)))

y_max <- y_min #*-1  # *-1 fordi reversed scale
y_min <- y_max - 1   # + 1 i stedet for -1 fordi reversed scale

.data$y_min <- y_min
.data$y_max <- y_max

## DATAFRAME FOR GGPLOT
test1 <- .data %>%
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

