context('RAW test files')

test_that("Verify there are test files.", {
  expect_equal(length(dir(system.file("extdata",package="RAWdataR"))),4)
})
