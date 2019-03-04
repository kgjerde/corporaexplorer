# To comply with R CMD check
# See https://stackoverflow.com/questions/9439256/how-can-i-handle-r-cmd-check-no-visible-binding-for-global-variable-notes-when
utils::globalVariables(
    c(
        "Date",
        "Diff",
        "Month_n",
        "Text",
        "Text_case",
        "Weekday_n",
        "Year" ,
        "Yearday_n",
        "count",
        "i",
        "j",
        "id",
        "word"
    )
)