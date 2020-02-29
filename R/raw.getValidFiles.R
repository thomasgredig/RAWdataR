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
  f1 = file.list[sapply(strsplit(file.list,'_'),length)>=5]
  f1[sapply(strsplit(f1,'_'),length)<=6]
}


#' returns all invalid RAW files in a folder
#'
#' @param pfad path to the RAW folder
#' @param year 4-digit year to limit search
#' @return vector with filenames
#' @examples
#' raw.getInvalidFiles('.')
#'
#' @export
raw.getInvalidFiles <- function(pfad, year='.*') {
  file.list = dir(pfad,pattern=paste0('^',year,'[^_]'))
  f1 = file.list[sapply(strsplit(file.list,'_'),length)!=6]
  f1[sapply(strsplit(f1,'_'),length)!=5]
}
