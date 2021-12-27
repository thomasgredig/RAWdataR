#' returns the MD5sum of a filename
#'
#' @param filename filename
#' @param num string length
#' @return CRC MD5 sum for this particular file
#' @examples
#' raw.getMD5(raw.getSampleFiles(),num=10)
#'
#' @export
raw.getMD5 <- function(filename,num=6) {
  fdel=c()
  for(c in 1:length(filename)) {
    if (!file.exists(filename[c])) { fdel=c(fdel,c)}
  }
  # remove files that cannot be found
  if(length(fdel)>0) filename=filename[-fdel]
  substr(tools::md5sum(filename),1,num)
}
#' @export
raw.getPartialMD5 <- function(filename,num=6) { raw.getMD5(filename, num) }
#' returns a string with all MD5 files
#'
#' @param filename filename with path
#' @return CRC MD5 sum for this particular file
#' @examples
#' raw.getMD5str(raw.getSampleFiles())
#'
#' @export
raw.getMD5str <- function(filename) {
  paste0(as.vector(raw.getMD5(filename)),collapse=',')
}
#' @export
raw.getPartialMD5str <- function(filename) { raw.getMD5str(filename) }

