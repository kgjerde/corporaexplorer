# Autoscrolling til toppen når nytt dokument trykkes
shinyjs::runjs(sprintf("$('.boxed_doc').scrollTo('#%s');", 1))

if (plot_mode$mode == "data_365") {

    kanin <-
        5 +
        (30 *
             ((length(
                 which(
                     session_variables$data_dok$Date ==
                         session_variables[[plot_mode$mode]]$Date[min_rad]
                 )
             )
             %/% 15.5) + 1))
    
    
    shinyjs::runjs(sprintf(
        "$('.ost .nav-tabs-custom').css({
            'top' : %f + 140 + 'px'
        });",
        kanin
    ))
    
} else if (plot_mode$mode == "data_dok") {
    shinyjs::runjs("$('.ost .nav-tabs-custom').css({
            'top' : 60 + 'px',
        });")
    
}
