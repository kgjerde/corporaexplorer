library(corpusexplorationr)
library(shinytest)

context("Extractor: Basic search works")

test_that("Extractor: Search works", {
    app <- ShinyDriver$new("../")
    app$snapshotInit("search_test")
    app$snapshot()
    app$setInputs(search_text = "april")
    app$setInputs(trykk = "click")

    output <- app$getValue(name = "info")
    expect_true(stringr::str_detect(output, "april is found a total of 2 times in 2 documents"))

    app$setInputs(case_sensitivity = TRUE)
    app$setInputs(trykk = "click")

    output <- app$getValue(name = "info")
    expect_true(stringr::str_detect(output, "april is found a total of 0 times in 0 documents"))
})

