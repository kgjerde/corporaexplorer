
# For K. Benoit, in case his review is on-going ---------------------------
# For objects from 0.4.0 --------------------------------------------------

if ("mnd_vert" %in% colnames(loaded_data$original_data$data_365)) {
    loaded_data$original_data$data_dok <-
        dplyr::rename(loaded_data$original_data$data_dok,
               Tile_length = wc,
               ID = id,
               Text_original_case = Text_case)

    loaded_data$original_data$data_365 <-
        dplyr::rename(loaded_data$original_data$data_365,
                      Invisible_fake_date = ID)

    loaded_data$original_data$data_365$Invisible_fake_date[loaded_data$original_data$data_365$Invisible_fake_date != 0] <- -1
    loaded_data$original_data$data_365$Invisible_fake_date[loaded_data$original_data$data_365$Invisible_fake_date == 0] <- 1
    loaded_data$original_data$data_365$Invisible_fake_date[loaded_data$original_data$data_365$Invisible_fake_date == -1] <- 0
    loaded_data$original_data$data_365$Invisible_fake_date <-
        as.logical(loaded_data$original_data$data_365$Invisible_fake_date)

    loaded_data$original_data$data_365 <-
        dplyr::rename(loaded_data$original_data$data_365,
               Tile_length = wc,
               ID = id,
               Day_without_docs = empty)

    loaded_data$original_data$data_365 <-
        dplyr::select(loaded_data$original_data$data_365,
                      -No., -Week_n, -mnd_vert, -mnd_hor, -Month_n, -Yearday_n)
}

if (is.null(loaded_data$date_based_corpus)) {
    loaded_data$date_based_corpus <- TRUE
}
