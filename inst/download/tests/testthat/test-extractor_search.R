library(shinytest2)

test_that("Extractor: Search works", {
    app <- AppDriver$new(name = "extractor_search_test")

    app$set_inputs(search_text = "april")
    app$click("trykk")

    output <- app$get_value(output = "info")
    expect_true(stringr::str_detect(output, "april is found a total of 2 times in 2 documents"))

    app$set_inputs(case_sensitivity = TRUE)
    app$click("trykk")

    output <- app$get_value(output = "info")
    expect_true(stringr::str_detect(output, "april is found a total of 0 times in 0 documents"))
})
