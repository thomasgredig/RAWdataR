#' Return filename by ID
#'
#' @param file.list list of file names
#' @param pRESULTS results folder, if missing and path.RESULTS is defined will use that folder
#' @param idFile name of the file the the RAW IDs
#' @param exactNameMatch logical, if \code{FALSE} will match partial file names
#'
#' @seealso \code{\link{raw.getIDbyFile}}, \code{\link{raw.updateID}}
#'
#' @export
raw.getIDbyFile <- function(file.list,
                            pRESULTS = 'data-raw',
                            idFile = 'RAW-ID.csv',
                            exactNameMatch = TRUE) {

  # name for file that stores the RAW IDs
  fIDfile = file.path(pRESULTS, idFile)
  if(!file.exists(fIDfile)) {
    warning("Please run first raw.updateID() to generate RAW-ID file.")
    return(NULL)
  }

  rID = raw.readRAWIDfile(fIDfile)


  m = c()
  for(f in file.list) {
    if (exactNameMatch) {
      if (file.exists(f)) {
        crc = .getCRC(f)
        m1 = which(crc == rID$crc)
        if (length(m1)==0 | length(m1)>1) warning("Run raw.updateID() first.")
      } else {
        fn = basename(f)
        m1 = which(fn == rID$filename)
        if (length(m1)==0 | length(m1)>1) warning("Run raw.updateID() first.")
      }
    } else {
      # match can be approximate
      m1 = grep(f, file.path(rID$path, rID$filename))
    }

    if (length(m1)>0) {
      m = c(m, m1)
    }
  }
  rID[m,]
}
