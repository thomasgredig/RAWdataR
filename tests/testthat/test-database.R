test_that("check SQL database search", {
  f = raw.getDatabase('randomPckname')
  expect_true(is.null(f))
})
