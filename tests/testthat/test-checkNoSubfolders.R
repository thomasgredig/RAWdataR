library(testthat)
test_that("checks that there are no subfolders", {
  expect_true(!raw.checkNoSubfolders(R.home(component="home")))
})
