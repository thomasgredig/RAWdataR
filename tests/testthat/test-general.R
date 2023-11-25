test_that("go up one directory", {
  p = path.goUpOneDir('/Users/test/fish-100')
  expect_equal(p,'/Users/test')
})


# generate a random file
.randomFile <- function(pRAW) {
  fout = file.path(pRAW, paste0('file',floor(runif(1,100,1e4)),'.txt'))
  df = data.frame(no = runif(10))
  write.csv(df, fout)
  fout
}


test_that("split filename and search for sample names", {
  f = c('20010101_project_user_inst_sample_desc.DAT')
  f = c(f,f,f)
  df = raw.splitFilename(f)
  expect_equal(nrow(df), 3)
  expect_equal(df$Sample, c("sample","sample","sample"))
})


test_that("test RAW ID", {
  pRESULTS = tempdir()

  pRAW = file.path(pRESULTS,'RAW')
  if (!dir.exists(pRAW)) dir.create(pRAW)

  # create RAW ID file and expect it to be empty
  q = raw.updateID(pRAW, pRESULTS, forceRegenerate = TRUE, verbose=FALSE)
  expect_equal(nrow(q),0)

  .randomFile(pRAW) -> f1

  # update RAW ID, should have 3 files now
  q = raw.updateID(pRAW, pRESULTS, verbose=FALSE)
  expect_equal(nrow(q),1)
  firstID = raw.getIDbyFile(f1, pRESULTS)

  .randomFile(pRAW) -> f2
  .randomFile(pRAW) -> f3

  q = raw.updateID(pRAW, pRESULTS, verbose=FALSE)

  f1.ID = raw.getIDbyFile(f1, pRESULTS)
  expect_equal(f1.ID$ID, firstID$ID)

  # rename one file
  f1.new = paste0(f1,'.newFile')
  file.rename(from=f1, to=f1.new)
  q = raw.updateID(pRAW, pRESULTS, verbose=FALSE)
  expect_equal(nrow(q),3)
  expect_equal(length(which(q$missing)),0)

  f1.ID = raw.getIDbyFile(f1.new, pRESULTS)
  expect_equal(f1.ID$ID, firstID$ID)

  # move all files into a new directory
  dir.create(file.path(pRAW,'sub'))
  .randomFile(pRAW) -> f4
  .randomFile(pRAW) -> f5
  # switch two files
  f5.new = file.path(pRAW,'sub',basename(f5))
  f4.new = file.path(pRAW,'sub',basename(f4))
  f2.new = file.path(pRAW,'sub',basename(f2))

  file.rename(from=f2, to=f2.new)
  file.rename(from=f4, to=f4.new)
  file.rename(from=f5, to=f5.new)

  file.remove(f3)
  q = raw.updateID(pRAW, pRESULTS, fixDuplicates=TRUE, verbose=FALSE)
  expect_equal(length(which(q$missing)),1)

  # find approximate match, evertyhing in the "sub" folder:
  n = raw.getIDbyFile('sub', pRESULTS, exactNameMatch = FALSE)
  expect_equal(nrow(n), 3)
})


test_that("Check Variable Formats in RAW file", {
  pRESULTS = tempdir()
  pRAW = file.path(pRESULTS,'RAW')
  if (!dir.exists(pRAW)) dir.create(pRAW)

  .randomFile(pRAW) -> f1
  .randomFile(pRAW) -> f2

  rID = raw.updateID(pRAW, pRESULTS, verbose=FALSE)
  expect_true(all(rID$crc > 0))

  expect_true(all(rID$size > 0) )

  # check dates
  expect_true(all(format(as.Date(rID$date),"%Y") >= 2023))
})
