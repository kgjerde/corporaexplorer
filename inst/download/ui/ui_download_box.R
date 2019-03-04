shinydashboard::box(
    width = 12,
    title = "Choose download type",
    
    shinyWidgets::radioGroupButtons(
        inputId = "download_type",
        label = NULL,
        #"Choose download type",
        choices = list(
            "One large txt file" = "txt",
            "Zip file of txt files" = "zip",
            "HTML" = "html"
        ),
        selected = "",
        justified = TRUE,
        size = "s"
    ),
    
    shiny::conditionalPanel(
        condition = "input.download_type == 'txt'",
        shiny::downloadButton("download_txt",
                       label = shiny::textOutput('download_button_text_txt'),
                       class = NULL)
    ),
    
    shiny::conditionalPanel(
        condition = "input.download_type == 'zip'",
        shiny::downloadButton("download_zip",
                       label = shiny::textOutput('download_button_text_zip'),
                       class = NULL)
    ),
    
    shiny::conditionalPanel(
        condition = "input.download_type == 'html'",
        shiny::downloadButton("download_html",
                       label = shiny::textOutput('download_button_text_html'),
                       class = NULL)
    )
)
