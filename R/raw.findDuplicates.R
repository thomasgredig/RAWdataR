#' Find duplicate RAW files
#'
#' Date: 2018-11-21
#' Searches a directory for all files (not necessarily coded properly), then returns a vector with files that have a duplicate.
#'
#' @param pfad path to search for duplicate files
#' @param fromLast if \code{TRUE}, last element is kept, if \code{FALSE}, first element is kept, default is \code{TRUE}
#' @param isValid if \code{TRUE} only search valid named files
#' @return list of files that are duplicates
#' @export
raw.findDuplicates <- function(pfad, fromLast=TRUE, isValid=FALSE) {
  file.list = file.path(pfad,dir(pfad))
  if (isValid) file.list = file.list[raw.isValid(file.list)]
  md5 = raw.getMD5(file.list)
  which(duplicated(md5)==TRUE)
  file.list[duplicated(md5, fromLast)]
}
