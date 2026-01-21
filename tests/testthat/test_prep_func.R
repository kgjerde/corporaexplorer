test_that("prepare_data() works", {
  # Creates test data set ---------------------------------------------------
  test_obj <- create_test_data()

  # Checks for equality -----------------------------------------------------
  # Using waldo under the hood so presumably minor differences in attributes are ignored
  testthat::expect_equal(
    test_obj,
    corporaexplorer::test_data
  )
})
