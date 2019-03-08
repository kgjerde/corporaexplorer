context("Prepare data")

library(testthat)
library(corpusexplorationr)

test_that("prepare_data() works", {

  # Creates test data set ---------------------------------------------------
  test_obj <- create_test_data()

  # Checks for equality -----------------------------------------------------
  expect_equal(test_obj, corpusexplorationr::test_data)
})
