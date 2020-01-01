#' returns all valid RAW files in a folder
#'
#' @param pfad path to the RAW folder
#' @return vector with filenames
#' @examples
#' raw.getValidFiles('.')
#'
#' @export
raw.getValidFiles <- function(pfad) {
  file.list = dir(pfad,pattern='^[^_]')
  file.list[sapply(strsplit(file.list,'_'),length)==6]
}


#' returns all invalid RAW files in a folder
#'
#' @param pfad path to the RAW folder
#' @return vector with filenames
#' @examples
#' raw.getInvalidFiles('.')
#'
#' @export
raw.getInvalidFiles <- function(pfad) {
  file.list = dir(pfad,pattern='^[^_]')
  file.list[sapply(strsplit(file.list,'_'),length)!=6]
}
