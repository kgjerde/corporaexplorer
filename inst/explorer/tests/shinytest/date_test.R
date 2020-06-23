library(corporaexplorer)
library(shinytest)

context("Explorer: Date test")

test_that("Explorer: Dates work", {
    app <- shinytest::ShinyDriver$new("../..")
    app$snapshotInit("date_test")
    app$snapshot()
    app$setInputs(search_text_1 = "october")
    app$setInputs(search_button = "click")

    output <- app$getValue(name = "date_slider")

    expect_equal(output[1], 2011)
    expect_equal(output[2], 2020)
})

