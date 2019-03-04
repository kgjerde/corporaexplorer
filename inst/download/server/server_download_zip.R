

output$download_zip <-
    shiny::downloadHandler(
        filename = "downloaded.zip",
        content = function(fname) {
    progress <- shiny::Progress$new()
    # Make sure it closes when we exit this reactive, even if there's an error
    on.exit(progress$close())
    progress$set(message = "Preparing zip file", value = 0)
            
            tmpdir <- paste(sep = "/",
                            tempdir(),
                            session$token)
       
            dir.create(tmpdir)
         
            filelist <- c()
            
            for (i in seq_len(nrow(sv$subset))) {
                filename <-
                    sprintf('%s/%s.txt', tmpdir, i)
                
                readr::write_lines(sv$subset$Text[i],
                            filename)
                filelist <- c(filelist,
                              filename)
            }
            
                zip::zip(zipfile = fname,
                         files = filelist#,
                         #   flags = "-jr9X")
                         )

        }
            )

# output$download_zip <-
#     shiny::downloadHandler(
#         filename = "downloaded.zip",
#         content = function(fname) {
#             progress <-
#                 ipc::AsyncProgress$new(message = "Preparing zip file.")
#             
#             tmpdir <- paste(sep = "/",
#                             tempdir(),
#                             session$token)
#        
#             dir.create(tmpdir)
#          
#             filelist <- c()
#             
#             for (i in seq_len(nrow(sv$subset))) {
#                 filename <-
#                     sprintf('%s/%s.txt', tmpdir, i)
#                 
#                 readr::write_lines(sv$subset$Text[i],
#                             filename)
#                 filelist <- c(filelist,
#                               filename)
#             }
#             
#             future::future(evaluator = future::plan(future_plan), {
#                 zip::zip(zipfile = fname,
#                          files = filelist#,
#                          #   flags = "-jr9X")
#                          )
#                 # Close the progress bar
#                          progress$close()
#             })
#         }
#             )
