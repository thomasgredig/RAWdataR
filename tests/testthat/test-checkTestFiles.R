context('RAW test files')

test_that("Verify there are test files.", {
  expect_equal(length(dir(system.file("extdata",package="RAWdataR"))),4)
})

test_that("Find valid files.", {
    expect_equal(length(raw.getValidFiles(
      raw.getSamplePath())),3)
})

test_that("Find invalid files.", {
  expect_equal(length(raw.getInvalidFiles(
    raw.getSamplePath())),1)
})



test_that("Verify MD5 strings for files.", {
  md5str = raw.getMD5str(raw.getSampleFiles())
  expect_equal(md5str, "7545cd,7545cd,24fefa,7545cd")
})

test_that("Add instrument name", {
  raw.fixInvalidFile(f, instrument='vsm')
})
