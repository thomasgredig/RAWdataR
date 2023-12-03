# generate a random file
.randomFile <- function(pRAW) {
  fout = file.path(pRAW, paste0('file',floor(runif(1,100,1e4)),'.txt'))
  df = data.frame(no = runif(100))
  write.csv(df, fout)
  fout
}


test_that("Customize Sample Name", {
  pRESULTS = tempdir()
  pRAW = file.path(pRESULTS,'RAW1')
  if (!dir.exists(pRAW)) dir.create(pRAW)

  .randomFile(pRAW) -> f1
  .randomFile(pRAW) -> f2
  .randomFile(pRAW) -> f3

  # update RAW ID, should have 3 files now
  fID = raw.updateID(pRAW, pRESULTS, noData = TRUE, verbose=FALSE)
  q <- raw.readRAWIDfile(fID)
  fileTypes = q$type

  f1 <- function(x) { x$type="TXT"; x }
  q <- raw.updateID(pRAW, pRESULTS, f_post=f1, verbose=FALSE)
  fileTypes.new = q$type

  expect_true(!all(fileTypes==fileTypes.new))


})
