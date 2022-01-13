#' Returns all valid RAW files
#'
#'
#' Searches a folder for valid files
#'
#' @param pfad path to the RAW folder
#' @param recursive if \code{TRUE}, will also search sub-directories
#' @return vector with filenames
#' @examples
#' raw.getValidFiles(raw.getSamplePath())
#'
#' @export
raw.getValidFiles <- function(pfad, recursive=FALSE) {
  file.list = dir(pfad,pattern='', recursive = recursive)
  file.list[raw.isValid(file.list)]
}


#' Returns all invalid RAW files
#'
#' Searches a folder (and year) for files that could be invalid
#'
#' @param pfad path to the RAW folder
#' @param year limit to a particular year (currently ignored)
#' @param recursive if \code{TRUE}, will also search sub-directories
#' @return vector with filenames
#' @examples
#' raw.getInvalidFiles(raw.getSamplePath())
#'
#' @export
raw.getInvalidFiles <- function(pfad, year='.*', recursive=FALSE) {
  file.list = dir(pfad,pattern='', recursive = recursive)
  file.list[!raw.isValid(file.list)]
}
