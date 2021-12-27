test_that("Verify there are no subfolders", {
  expect_true(raw.checkNoSubfolders(raw.getSamplePath()))
})
