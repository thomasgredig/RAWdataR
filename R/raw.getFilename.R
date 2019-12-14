#' returns the filename with certain MD5sum
#'
#' @param file.list path and filenames
#' @return filename with certain checksum
#' @examples
#' raw.getFilename(dir(),'6')
#'
#' @export
raw.getFilename <- function(file.list, MD5) {
  filename = NA
  for(f in file.list) {
    if (!dir.exists(f)) {
      if (substr(md5sum(f),1,nchar(MD5))==MD5) {
        filename = f
        break;
      }
    }
  }
  filename
}


#' returns the MD5sum of a filenam
#'
#' @param filename filename
#' @param num string length
#' @return CRC MD5 sum for this particular file
#' @examples
#' raw.getMD5('README.md')
#'
#' @export
raw.getPartialMD5 <- function(filename,num=6) {
  if (!file.exists(filename)) return(NA)
  substr(md5sum(filename),1,num)
}
