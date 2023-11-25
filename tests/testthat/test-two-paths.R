test_that("Find files in two Paths", {
  pMain = tempdir()

  pRESULTS = file.path(pMain,'data-raw')
  if (!dir.exists(pRESULTS)) dir.create(pRESULTS)

  # create directories
  pUser1 = file.path(pMain,'user-TG1')
  if (!dir.exists(pUser1)) dir.create(pUser1)
  pRAW1 = file.path(pMain,'user-TG1','RAW')
  if (!dir.exists(pRAW1)) dir.create(pRAW1)

  pUser2 = file.path(pMain,'user-test1')
  if (!dir.exists(pUser2)) dir.create(pUser2)
  pRAW2 = file.path(pMain,'user-test1','RAW')
  if (!dir.exists(pRAW2)) dir.create(pRAW2)


  # generate a random file
  .randomFile <- function(pRAW) {
    fout = file.path(pRAW, paste0('file',floor(runif(1,100,1e4)),'.txt'))
    df = data.frame(no = runif(10))
    write.csv(df, fout)
    fout
  }

  # add random files into userdirectories

  .randomFile(pRAW2)
  .randomFile(pRAW2)

  .randomFile(pRAW1)
  .randomFile(pRAW1)
  .randomFile(pRAW1)

  # create RAW ID file and expect it to be empty
  q = raw.updateID(pRAW2, pRESULTS, forceRegenerate = TRUE, verbose=FALSE)
  fID = file.path(pRESULTS,'RAW-ID.csv')
  q = raw.readRAWIDfile(fID)
  expect_equal(nrow(q),2)

  q = raw.updateID(pRAW1, pRESULTS, verbose=FALSE)
  expect_equal(nrow(q),5)

  q = raw.readRAWIDfile(fID)
  expect_equal(all(q$missing), FALSE)
})
