# Auto scroll to top when new tile clicked --------------------------------
shinyjs::runjs(sprintf("$('.boxed_doc_%s').scrollTo('#%s');",
                       plot_mode$mode,
                       1))
shinyjs::runjs(sprintf("$('#dag_kart').scrollTo('%s');", 0))


# Positioning of UI elements depending on height of other -----------------
if (plot_mode$mode == "data_365") {

    div_height <- session_variables$day_plot_height
    max_height <- 200  # corresponds to max-height in css for #dag_kart

    if (div_height > max_height) div_height <- max_height

    shinyjs::runjs(sprintf(
        "$('.class_doc_box .nav-tabs-custom').css({
            'top' : %f + 140 + 'px'
        });",
        div_height
    ))

} else if (plot_mode$mode == "data_dok") {
    shinyjs::runjs("$('.class_doc_box .nav-tabs-custom').css({
            'top' : 60 + 'px',
        });")

}
