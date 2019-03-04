library(testthat)
library(shinytest)

source("../../global/server_count_function.R", local = TRUE)

context("Date test")

# test_that("shinytesting - finally working", {
#         expect_pass(testApp(appDir = "../..",
#                         testnames = "mytest.R",
#                         compareImages = F))
# })

app <- ShinyDriver$new("../..")
test_that("shiny driver", {
    app$setInputs(search_text = "october")
    app$setInputs(trykk = "click")

    output <- app$getValue(name = "date_slider")

    expect_equal(output[1], 2011)
    
})

context("Plot name test")

app <- ShinyDriver$new("../..")
test_that("shiny2", {
# app$setInputs(search_text = "october")
# app$setInputs(trykk = "click")
output <- app$getValue(name = "korpuskarttittel")
expect_equal(output, "Calendar view")
app$setInputs(modus = "data_dok")
app$setInputs(trykk = "click")
output <- app$getValue(name = "korpuskarttittel")
expect_equal(output, "Document wall view")

})
