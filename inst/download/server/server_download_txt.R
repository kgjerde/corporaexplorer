output$download_txt <-
    shiny::downloadHandler(
        filename = "downloaded.txt",
        content = function(fname) {
            
                # Create a Progress object
    progress <- shiny::Progress$new()
    # Make sure it closes when we exit this reactive, even if there's an error
    on.exit(progress$close())
    progress$set(message = "Preparing txt file", value = 0)
            
            # progress <-
            #     ipc::AsyncProgress$new(message = "Preparing txt file.")
            ned_tekst <- paste0(sv$subset$Text, "\n___\n")
            # future::future(evaluator = future::plan(future_plan), {
                data.table::fwrite(
                    list(ned_tekst),
                    file = fname,
                    quote = FALSE,
                    col.names = FALSE,
                    sep2 = c("", "\n", "")
                )
            # })
        }
    )



# output$download_txt <-
#     shiny::downloadHandler(
#         filename = "downloaded.txt",
#         content = function(fname) {
#             progress <-
#                 ipc::AsyncProgress$new(message = "Preparing txt file.")
#             ned_tekst <- paste0(sv$subset$Text, "\n___\n")
#             future::future(evaluator = future::plan(future_plan), {
#                 data.table::fwrite(
#                     list(ned_tekst),
#                     file = fname,
#                     quote = FALSE,
#                     col.names = FALSE,
#                     sep2 = c("", "\n", "")
#                 )
#                 progress$close()
#             })
#         }
#     )
