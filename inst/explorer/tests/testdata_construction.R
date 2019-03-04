# Creates test data set ---------------------------------------------------

dates <- as.Date(paste(2011:2020, 1:10, 21:30, sep = "-"))
texts <- paste0("This is a document about ", month.name[1:10], ". ",
                "This is not a document about ", rev(month.name[1:10]), ".")
titles <- paste("Text", 1:10)


test_df <- tibble(Date = dates, Text = texts, Title = titles)

source("Pre-scripts/prepare_data.R")

loaded_data <- prepare_data(test_df, "test corpus", python_matrix = TRUE)

saveRDS(loaded_data, "tests/testdata.rds")

fake_search_arguments <-
    list(
        treshold = NA,
        subset_terms = NULL,
        case_sensitive = FALSE,
        tresholds = c(NA_real_, NA_real_),
        terms_highlight = c("october",
                            "document"),
        search_terms = c("october", "document"),
        subset_search = FALSE
    )


library(testthat)

library(stringr)

test_that("str_length is number of characters", {
  expect_equal(str_length("a"), 1)
  expect_equal(str_length("ab"), 22)
  expect_equal(str_length("abc"), 3)
})

###

library(shinytest)

recordTest()

