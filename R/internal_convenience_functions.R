#' Retrieve the document data frame from a corporaexplorerobject
#'
#' @param x corporaexplorerobject
#'
#' @return data.frame
#' @keywords internal
get_df <- function(x, make_normal = TRUE) {
    df <- x$original_data$data_dok
    if (make_normal == TRUE) {
        df$Text_column_ <- df$Text_original_case
        df$cx_ID <- NULL
        df$Text_original_case <- NULL
        df$Tile_length <- NULL
        df$Year_ <- NULL
        df$cx_Seq <- NULL
        df$Weekday_n <- NULL
        df$Day_without_docs <- NULL
        df$Invisible_fake_date <- NULL
        df$Tile_length <- NULL
        # "Return" previous name to column designated as text_column
        df[[x$text_column]] <- df$Text_column_
        df$Text_column_ <- NULL
    }
    return(df)
}
