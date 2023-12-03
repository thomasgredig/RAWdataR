test_that("finds RAW ID file", {
  q <- raw.RAWIDfile()
  # clean up directory after test
  if (nchar(q)>0) file.remove(dirname(q))
  expect_true(nchar(q)>0)
})
