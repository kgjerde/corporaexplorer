
# For K. Benoit, in case his review is on-going ---------------------------
# For objects from 0.4.0 --------------------------------------------------

if ("mnd_vert" %in% colnames(abc$original_data$data_365)) {
    abc$original_data$data_dok <-
        dplyr::rename(abc$original_data$data_dok,
               Text_original_case = Text_case)
}
