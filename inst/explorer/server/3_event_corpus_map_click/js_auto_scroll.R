# Auto scroll to top when new tile clicked --------------------------------
shinyjs::runjs(sprintf("$('.boxed_doc_%s').scrollTo('#%s');",
                       plot_mode$mode,
                       1))
shinyjs::runjs(sprintf("$('#dag_kart').scrollTo('%s');", 0))
shinyjs::runjs(sprintf("$('#extra').scrollTo('%s');", 0))
