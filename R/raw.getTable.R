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
  if (project=='') {
    file.list = dir(pfad,pattern='^[^_]')
  } else {
    file.list = dir(pfad, paste0('.*_',project,'_'))
  }
  d = data.frame()
  for(f in file.list) {
    d = rbind(d, raw.splitFilename(f))
  }
  d
}
