#' returns the filename with certain MD5sum
#'
#' @param file.list path and filenames
#' @param MD5 checksum, can be any length
#' @return filename with certain checksum
#' @examples
#' raw.getFilename(dir(),'6b')
#'
#' @export
raw.getFilename <- function(file.list, MD5) {
  filename = NA
  for(f in file.list) {
    if (!dir.exists(f)) {
      if (substr(tools::md5sum(f),1,nchar(MD5))==MD5) {
        filename = f
        break;
      }
    }
  }
  filename
}
