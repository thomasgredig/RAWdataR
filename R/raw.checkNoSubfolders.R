#' Subfolders in RAW path
#'
#' The RAW path should not contain subfolders; the reason for
#' this is that subfolders tend to have additional information in
#' the folder name, which then makes the file less unique.
#'
#' @param pfad path to the RAW folder
#' @return \code{TRUE} if there are no subfolders
#' @examples
#' raw.checkNoSubfolders(raw.getSamplePath())
#' @export
raw.checkNoSubfolders <- function(pfad) {
  if(!dir.exists(pfad)) { warning('RAW folder not found.') }
  (length(list.dirs(pfad)) == 1)
}
