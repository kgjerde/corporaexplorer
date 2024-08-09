# This file is for testing the applications in the inst/ directory.

library(shinytest2)

test_that("explorer app works", {
    # Don't run these tests on the CRAN build servers
    skip_on_cran()

    appdir <- system.file(package = "corporaexplorer", "download")
    test_app(appdir)
})
