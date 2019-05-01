source("./global/corpus_plot_functions/colours_to_plot_and_legend.R",local = TRUE)
source("./global/corpus_plot_functions/count_search_terms_hits.R",local = TRUE)
source("./global/corpus_plot_functions/create_coordinates_several_terms.R",local = TRUE)
source("./global/corpus_plot_functions/create_factors_for_labelling.R",local = TRUE)
source("./global/corpus_plot_functions/label_axes.R", local = TRUE)

source("./global/corpus_plot_functions/create_coordinates_1_data_365.R",local = TRUE)
source("./global/corpus_plot_functions/create_distance_coordinates_365.R",local = TRUE)
source("./global/corpus_plot_functions/plotting_corpus_data_365.R",local = TRUE)

source("./global/corpus_plot_functions/create_coordinates_1_data_dok.R",local = TRUE)
source("./global/corpus_plot_functions/plotting_corpus_data_dok.R",local = TRUE)

source("./global/corpus_plot_functions/create_distance_coordinates_day.R",local = TRUE)
source("./global/corpus_plot_functions/plotting_corpus_day.R",local = TRUE)

#' Corpus map/plot constructor
#'
#' The main function for creation of corpus maps in three different formats:
#' calendar view, document brick wall view, and 'a day in the corpus' view (when
#' a is clicked in calendar view).
#' @param .data A data frame corresponding to the plot mode (data_365 or
#'   data_dok).
#' @param .width Max width of x axis in plot.
#' @param matriksen Corpus matrix.
#' @param ordvektor Corpus word vector.
#' @param number_of_factors Max number of groups for labelling of search term
#'   hits.
#' @param doc_df The data_dok data frame, invoked for search if modus ==
#'   "data_365".
#' @param search_arguments List containing search arguments.
#' @param modus One of "data_365", "data_dok", or "day".
#'
#' @return A ggplot2 plot object.
visualiser_korpus <-
  function(.data,
           .width = "auto",
           matriksen = loaded_data$original_matrix$data_dok,
           ordvektor = loaded_data$ordvektorer$data_dok,
           number_of_factors = 8,
           doc_df,
           search_arguments,
           modus) {

    linjer <- length(search_arguments$search_terms)
    .data$Month <- lubridate::month(.data$Date)
    
# 1. Check if search contains search terms --------------------------------
    
    if (identical(search_arguments$search_terms, "")) {
      .data$Term_1 <- NA

    } else{

# 2. Count search term hits and assign factors for labelling --------------
      
      .data <-
        count_search_terms_hits(.data,
                                search_arguments,
                                matriksen,
                                ordvektor,
                                doc_df,
                                modus) %>%
        create_factors_for_labelling(., .data,
                                     search_terms = search_arguments$search_terms,
                                     number_of_factors)
    }

# 3. Create plot coordinates, step 1 --------------------------------------

    if (modus == "data_365") {
     # width = 53 # fordi uker
      .data$label_id <- seq_len(nrow(.data))
      .data <- create_coordinates_1_data_365(.data)
    } else if (modus == "data_dok") {
      
      .data <- create_coordinates_1_data_dok(.data, linjer)
    } else if (modus == "day") {

      .data <- create_coordinates_1_data_dok(.data, linjer, width = 15)
    }

# 4. Create plot coordinates, step 2 (if search terms > 1) ----------------

    .data <-
      create_coordinates_several_search_terms(.data, linjer)
    .data <- dplyr::select(.data, -dplyr::starts_with("Term_"))
    
# 5. Create plot coordinates, step 3 (distance between days etc.) ---------
   
    if (modus == "data_365") {
      .data <- create_distance_coordinates_365(.data,
                                               linjer,
                                               day_distance,
                                               month_distance,
                                               year_distance)
    } else if (modus == "data_dok") {
      #AVSTAND MELLOM ÅR
      year_distance <- 1
      .data$Year_numeric <- as.numeric(factor(.data$Year, levels = unique(.data$Year)))
      .data$y_min <- .data$y_min + (year_distance * .data$Year_numeric - min(.data$Year_numeric))
      .data$y_max <- .data$y_max + (year_distance * .data$Year_numeric - min(.data$Year_numeric))
    } else if (modus == "day"){
      .data <- create_distance_coordinates_day(.data,
                                                linjer,
                                                day_distance)
    }
    
# 6. Label x and y axes ---------------------------------------------------
    y_text <- label_y_axis(.data)
    
    if (modus == "data_365") {
      x_breaks <- label_x_axis_365(.data)
    }
    
# 7. Assign colours to plot labels/factors (up to 2 terms) ----------------

    temp_variable_for_unpacking <- colours_to_plot_and_legend(.data, linjer, number_of_factors)
    .data <- temp_variable_for_unpacking[[1]]  # colours_to_plot_and_legend(.data, linjer, number_of_factors)[[1]]
    til_legend <- temp_variable_for_unpacking[[2]] # colours_to_plot_and_legend(.data, linjer, number_of_factors)[[2]]
    
# 8. ggplotting -----------------------------------------------------------

    if (modus == "data_365") {
      plotting_corpus_data_365(.data, x_breaks, y_text, til_legend, linjer)
    } else if (modus == "data_dok") {
      plotting_corpus_data_dok(.data, y_text, til_legend, linjer)
    } else if (modus == "day") {
      plotting_corpus_day(.data, linjer)
    }
  }
