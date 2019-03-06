output$download_html <- shiny::downloadHandler(
    # For PDF output, change this to "report.pdf"
    filename = "report.html",
    content = function(file) {
        # Copy the report file to a temporary directory before processing it, in
        # case we don't have write permissions to the current working dir (which
        # can happen when deployed).
        tempReport <-
            file.path(tempdir(), "report-render.Rmd")
        file.copy("rmd/report-render.Rmd", tempReport, overwrite = TRUE)

        # Set up parameters to pass to Rmd document
        params <- list(dataset = sv$subset,
                       #subset_terms = collect_subset_terms(),
                       terms_highlight = search_arguments$highlight_terms,
                       case_sensitive = search_arguments$case_sensitive,
                       INFO_COLUMNS = INFO_COLUMNS)

        # Knit the document, passing in the `params` list, and eval it in a
        # child of the global environment (this isolates the code in the document
        # from the code in this app).
            progress <- shiny::Progress$new()
    # Make sure it closes when we exit this reactive, even if there's an error
    on.exit(progress$close())
    progress$set(message = "Preparing HTML file. This can take some time.", value = 0)

            rmarkdown::render(
                tempReport,
                output_file = file,
                params = params,
                envir = new.env(parent = globalenv()),
                quiet = TRUE
            )

    }
)

#
# output$download_html <- shiny::downloadHandler(
#     # For PDF output, change this to "report.pdf"
#     filename = "report.html",
#     content = function(file) {
#         # Copy the report file to a temporary directory before processing it, in
#         # case we don't have write permissions to the current working dir (which
#         # can happen when deployed).
#         tempReport <-
#             file.path(tempdir(), "report-render.Rmd")
#         file.copy("rmd/report-render.Rmd", tempReport, overwrite = TRUE)
#
#         # Set up parameters to pass to Rmd document
#         params <- list(dataset = sv$subset,
#                        #subset_terms = collect_subset_terms(),
#                        terms_highlight = collect_highlight_terms(),
#                        case_sensitive = search_arguments$case_sensitive)
#
#         # Knit the document, passing in the `params` list, and eval it in a
#         # child of the global environment (this isolates the code in the document
#         # from the code in this app).
#
#         progress <-
#             ipc::AsyncProgress$new(message = "Preparing html document.")
#         future::future(evaluator = future::plan(future_plan), {
#             rmarkdown::render(
#                 tempReport,
#                 output_file = file,
#                 params = params,
#                 envir = new.env(parent = globalenv())
#             )
#             # Close the progress bar
#             progress$close()
#         })
#     }
# )
