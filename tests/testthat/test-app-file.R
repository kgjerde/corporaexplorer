# context("app-file")
# This file is for testing the applications in the inst/ directory.

# library(shinytest)

  # test_dir(appdir)

context("Date test")


  appdir <- system.file("explorer",
                        # "tests",
                        # "testthat",
                        package = "corpusexplorationr")

# test_that("shinytesting - finally working", {
#         expect_pass(testApp(appDir = "../..",
#                         testnames = "mytest.R",
#                         compareImages = F))
# })

# shiny::shinyOptions("data" = test_data)
# library(corpusexplorationr)
# shiny::shinyOptions("data" = test_data)

app <- shinytest::ShinyDriver$new(appdir) #("../..")

test_that("shiny driver", {
    app$setInputs(search_text = "october")
    app$setInputs(trykk = "click")

    output <- app$getValue(name = "date_slider")

    expect_equal(output[1], 2011)

})

context("Plot name test")

app <- shinytest::ShinyDriver$new(appdir)  #("../..")
test_that("shiny2", {
# app$setInputs(search_text = "october")
app$setInputs(trykk = "click")
output <- app$getValue(name = "korpuskarttittel")
expect_equal(output, "Calendar view")
app$setInputs(modus = "data_dok")
app$setInputs(trykk = "click")
output <- app$getValue(name = "korpuskarttittel")
expect_equal(output, "Document wall view")

})