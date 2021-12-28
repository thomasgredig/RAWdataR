#' returns all valid RAW files in a folder
#'
#' @param pfad path to the RAW folder
#' @return vector with filenames
#' @examples
#' raw.getValidFiles(raw.getSamplePath())
#'
#' @export
raw.getValidFiles <- function(pfad) {
  file.list = dir(pfad,pattern='')
  file.list[raw.isValid(file.list)]
}


#' returns all invalid RAW files in a folder
#'
#' @param pfad path to the RAW folder
#' @return vector with filenames
#' @examples
#' raw.getInvalidFiles(raw.getSamplePath())
#'
#' @export
raw.getInvalidFiles <- function(pfad, year='.*') {
  file.list = dir(pfad,pattern='')
  file.list[!raw.isValid(file.list)]
}
