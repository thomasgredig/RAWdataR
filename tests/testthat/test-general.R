test_that("go up one directory", {
  p = path.goUpOneDir('/Users/test/fish-100')
  expect_equal(p,'/Users/test')
})


test_that("test RAW ID", {
  pRESULTS = tempdir()

  pRAW = file.path(pRESULTS,'RAW')
  if (!dir.exists(pRAW)) dir.create(pRAW)

  # create RAW ID file and expect it to be empty
  q = raw.updateID(pRAW, pRESULTS, forceRegenerate = TRUE)
  expect_equal(nrow(q),0)

  # generate a random file
  .randomFile <- function() {
    fout = file.path(pRAW, paste0('file',floor(runif(1,100,1e4)),'.txt'))
    df = data.frame(no = runif(10))
    write.csv(df, fout)
    fout
  }

  .randomFile() -> f1

  # update RAW ID, should have 3 files now
  q = raw.updateID(pRAW, pRESULTS)
  expect_equal(nrow(q),1)
  firstID = raw.getIDbyFile(f1, pRESULTS)

  .randomFile() -> f2
  .randomFile() -> f3

  q = raw.updateID(pRAW, pRESULTS)

  f1.ID = raw.getIDbyFile(f1, pRESULTS)
  expect_equal(f1.ID$ID, firstID$ID)

  # rename one file
  f1.new = paste0(f1,'.newFile')
  file.rename(from=f1, to=f1.new)
  q = raw.updateID(pRAW, pRESULTS)
  expect_equal(nrow(q),3)
  expect_equal(length(which(q$missing)),0)

  f1.ID = raw.getIDbyFile(f1.new, pRESULTS)
  expect_equal(f1.ID$ID, firstID$ID)

  # move all files into a new directory
  dir.create(file.path(pRAW,'sub'))
  .randomFile() -> f4
  .randomFile() -> f5
  # switch two files
  f5.new = file.path(pRAW,'sub',basename(f5))
  f4.new = file.path(pRAW,'sub',basename(f4))
  f2.new = file.path(pRAW,'sub',basename(f2))

  file.rename(from=f2, to=f2.new)
  file.rename(from=f4, to=f4.new)
  file.rename(from=f5, to=f5.new)

  file.remove(f3)
  q = raw.updateID(pRAW, pRESULTS, fixDuplicates=TRUE)
  expect_equal(length(which(q$missing)),1)
})
