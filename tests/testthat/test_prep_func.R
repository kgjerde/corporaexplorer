context("Prepare data")

library(testthat)
library(corporaexplorer)

test_that("prepare_data() works", {

  # Creates test data set ---------------------------------------------------
  test_obj <- create_test_data()

  # Checks for equality -----------------------------------------------------
  ## Using waldo so presumably minor differences in attributes are ignored
  comparison <- waldo::compare(
      test_obj,
      corporaexplorer::test_data
  )
  expect_length(comparison, 0)

})
