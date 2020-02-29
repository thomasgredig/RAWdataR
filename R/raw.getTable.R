#' returns a dataframe with field information for each file
#'
#' @param pfad path to the RAW folder
#' @param project project name limits files
#' @return dataframe
#' @examples
#' raw.getTable('.')
#'
#' @export
raw.getTable <- function(pfad, project='') {
  file.list = raw.findFiles(pfad, project)
  d = data.frame()
  for(f in file.list) {
    d = rbind(d, raw.splitFilename(f))
  }
  d
}
