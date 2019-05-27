#' returns number of files, but does not
#' include filenames that start with _, such
#' as _README.txt, which is not a data file
#'
#' @param pfad path to the RAW folder
#' @return number of files
#' @examples
#' raw.getNoFiles('.')
#'
#' @export
raw.getNoFiles <- function(pfad) {
  file.list = dir(pfad,pattern='^[^_]')
  length(file.list)
}
