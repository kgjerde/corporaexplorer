library(shinytest2)

test_that("Corpus info works", {
    app <- AppDriver$new(#app_dir = system.file("explorer",
        #                      package = "corporaexplorer"),
        name = "corpus_info_test")
    app$set_inputs(search_text_1 = "document")
    app$set_inputs(case_sensitivity = TRUE)
    app$click("search_button")
    app$set_inputs(corpus_box = "Corpus info")

    output <- app$get_value(output = "corpus_info")
    expect_true(stringr::str_detect(output, "The corpus contains 10 document"))

    output <- app$get_value(output = "TABLE")
    expect_true(stringr::str_detect(output, "2\\.00"))
})

test_that("Corpus info custom column search works", {
    app <- AppDriver$new(#"../..",
        name = "corpus_info_test_custom")
    app$set_inputs(search_text_1 = "2--Title")
    app$click("search_button")
    app$set_inputs(corpus_box = "Corpus info")

    output <- app$get_value(output = "TABLE")
    expect_true(stringr::str_detect(output, "Title"))
    expect_true(stringr::str_detect(output, "0\\.10"))
})

test_that("{shinytest2} recording: year filtering", {
    app <- AppDriver$new("../..", name = "year filtering")
    app$set_inputs(date_slider = c(2012, 2020))
    app$click("search_button")
    app$set_inputs(corpus_box = "Corpus info")
    output <- app$get_value(output = "corpus_info")
    expect_true(stringr::str_detect(output, "The filtered corpus contains 9 document"))
})
