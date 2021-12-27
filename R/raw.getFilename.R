#' returns the filename with certain MD5sum
#'
#' @param file.list path and filenames
#' @param MD5 checksum, can be any length
#' @return filename with certain MD5 checksum, returns \code{NA} if not found
#' @examples
#' file.list = file.path(raw.getSamplePath(),dir(raw.getSamplePath()))
#' raw.getFilenameByMD5(file.list,'6b')
#' @export
raw.getFilenameByMD5 <- function(file.list, MD5) {
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

#' OBSOLETE: return filename from MD5
#' @export
raw.getFilename <- function(file.list, MD5) {
  warning("Obsolete: call raw.getFilenameByMD5")
  raw.getFilenameByMD5(file.list, MD5)
}
