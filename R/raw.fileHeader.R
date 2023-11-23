#' Makes a RAW test folder
#'
#' @param noFiles number of random files to generate
#'
#' @export
makeRAWtestFolder <- function(noFiles=1) {
  #  example: raw.readRAWIDfile(file.path(makeRAWtestFolder(),'RAW-ID.csv'))
  pRESULTS = tempdir()
  pRAW = file.path(pRESULTS,'RAW')
  if (!dir.exists(pRAW)) dir.create(pRAW)

  for(n in 1:noFiles) {
    # add one test file
    fout = file.path(pRAW, paste0('file',floor(runif(1,100,1e4)),'.txt'))
    df = data.frame(no = runif(10))
    write.csv(df, fout)
  }
  # create RAW ID file and expect it to be empty
  raw.updateID(pRAW, pRESULTS, forceRegenerate = FALSE)

  pRESULTS
}
