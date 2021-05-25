output$info <- shiny::renderText({
    tekst <- sprintf("The corpus contains %s documents.",
                     format(nrow(abc), big.mark=","))
})
