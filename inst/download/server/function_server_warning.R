server_warning <- function() {
    shinydashboard::renderMenu({
        shinydashboard::dropdownMenu(
            shinydashboard::notificationItem(
                text = tags$div("Limited server capacity.",
                                tags$br(),
                                "App can be slow."),
                icon = shiny::icon("warning"),
                status = "warning",
                href = NULL
            ),
            type = c("notifications"),
            badgeStatus = "warning",
            icon = NULL,
            headerText = "Information:",
            .list = NULL
        )
    })
}


if (stringr::str_detect(Sys.info()[['nodename']], "small")) {
    output$dropdownmenu <- server_warning()
}
