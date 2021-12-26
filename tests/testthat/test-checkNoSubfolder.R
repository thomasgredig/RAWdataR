test_that("Verify there are no subfolders", {
  p = system.file("extdata",package="RAWdataR")
  expect_true(raw.checkNoSubfolders(p))
})
