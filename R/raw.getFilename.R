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
