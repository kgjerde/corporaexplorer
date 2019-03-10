    if (length(min_rad) > 0) {
        if (nrow(data_day) > 0) {

            session_variables$data_day <- data_day

                esel <-


                    visualiser_korpus(
                        session_variables$data_day,
                        search_arguments = search_arguments,
                        "auto",
                        matriksen = loaded_data$original_matrix$data_dok,
                        ordvektor = loaded_data$ordvektorer$data_dok,
                        number_of_factors = 4,
                        doc_df = session_variables$data_dok,
                        modus = "day"
                    )


            aa <<- session_variables$plotinfo_dag <-
                ggplot2::ggplot_build(esel)$data[[2]]


            output$dag_kart <- shiny::renderPlot({


            esel

},

height =
    function(x) {
rader <- length(unique(session_variables$plotinfo_dag$ymax))
    # 0 +
    #     (50 *
    #          ((nrow(data_day)
    #           %/% 15.5) + 1)) # 15.5 fordi width 15 i dokvis_2.r. konstant først fordi
    # dato og høyeste tall over selve graf. hackete hack
(15) + (rader * 30)


})
        }
    }
