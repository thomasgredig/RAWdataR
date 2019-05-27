#' returns a dataframe with field information for each file
#'
#' @param pfad path to the RAW folder
#' @return dataframe
#' @examples
#' raw.getTable('.')
#'
#' @export
raw.getTable <- function(pfad) {
  file.list = dir(pfad,pattern='^[^_]')
  d = data.frame()
  for(f in file.list) {
    d = rbind(d, raw.splitFilename(f))
  }
  d
}
