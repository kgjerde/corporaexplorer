#' Retrieve the document data frame from a corporaexplorerobject
#'
#' @param x corporaexplorerobject
#'
#' @return data.frame
#' @keywords internal
get_df <- function(x, make_normal = TRUE) {
    df <- x$original_data$data_dok

    if (make_normal == TRUE) {
        if (is.null(x$version)) {
            df$Text <- df$Text_case
            df$Text_case <- NULL
        } else {
            df$Text <- df$Text_original_case
            df$Text_original_case <- NULL
        }
        df$ID <- NULL
        df$Text_original_case <- NULL
        df$Tile_length <- NULL
        df$Year_ <- NULL
        df$Seq <- NULL
        df$Weekday_n <- NULL
        df$Day_without_docs <- NULL
        df$Invisible_fake_date <- NULL
        df$Tile_length <- NULL
    }
    return(df)
}
