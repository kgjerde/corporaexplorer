for (i in seq_along(MAIN_COLOURS)) {
  change_ui_class(
    paste0("#search_text_", i),
    "background-color",
    MAIN_COLOURS[i]
  )
}

change_ui_class("#search_text_1", "display", "block")
