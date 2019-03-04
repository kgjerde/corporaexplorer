output$info <- shiny::renderText({
    tekst <- sprintf("The corpus contains %i documents.",
                     nrow(abc))
})
