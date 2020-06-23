library(corporaexplorer)
library(shinytest)

context("Explorer: Corpus info")

test_that("Corpus info works", {
    app <- shinytest::ShinyDriver$new("../..")
    app$snapshotInit("corpus_info_test")
    app$snapshot()
    app$setInputs(search_text_1 = "document")
    app$setInputs(case_sensitivity = TRUE)
    app$setInputs(search_button = "click")
    app$setInputs(corpus_box = "Corpus info")

    # Check that corpus_info text is OK
    output <- app$getValue(name = "corpus_info")
    expect_true(stringr::str_detect(output, "The corpus contains 10 document"))

    # Check that parts of TABLE is OK
    output <- app$getValue(name = "TABLE")
    expect_true(stringr::str_detect(output, "2\\.00"))

})
