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
