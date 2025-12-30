# Auto scroll to top when new tile clicked --------------------------------
shinyjs::runjs("$('.class_doc_box .tab-content').scrollTo('0%');")
shinyjs::runjs(sprintf("$('#dag_kart').scrollTo('%s');", 0))
shinyjs::runjs(sprintf("$('#extra').scrollTo('%s');", 0))
