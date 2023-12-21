test_that("finds RAW ID file", {
  q <- raw.RAWIDfile()
  # clean up directory after test
  if (nchar(q)>0) file.remove(dirname(q))
  expect_true(nchar(q)>0)
})


test_that("Windows Folder", {
  f       <- "C:/Users/us1/OneDrive/Desktop/RAW/2023/20230224_TG_XRD.ras"
  pRAW    <- "C:\\Users\\us1\\OneDrive\\Desktop\\RAW"
  newPath <- .truncatePath(pRAW, dirname(f))
  expect_equal(newPath, "/2023")
})
