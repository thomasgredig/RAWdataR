test_that("go up one directory", {
  p = path.goUpOneDir('/Users/test/fish-100')
  expect_equal(p,'/Users/test')
})
