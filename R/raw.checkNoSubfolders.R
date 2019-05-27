#' Checks that the RAW folder contains no sub-folders
#'
#' @param pfad path to the RAW folder
#' @return boolean (true or false)
#' @examples
#' raw.checkNoSubfolders('.')
#'
#' @export
raw.checkNoSubfolders <- function(pfad) {
  if(!dir.exists(pfad)) { warning('RAW folder not found.') }
  (length(list.dirs(pfad)) == 1)
}
