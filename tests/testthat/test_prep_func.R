context("Prepare data")

library(testthat)
library(corporaexplorer)

test_that("prepare_data() works", {

  # Creates test data set ---------------------------------------------------
  test_obj <- create_test_data()

  # Checks for equality -----------------------------------------------------
  expect_equal(test_obj, corporaexplorer::test_data)
})
