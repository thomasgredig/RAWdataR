#' returns all project names
#'
#' @param pfad path to the RAW folder
#' @return vector with project names
#' @examples
#' raw.getNamesProjects('.')
#'
#' @export
raw.getNamesProjects <- function(pfad) {
  file.list = raw.getValidFiles(pfad)
  projects = lapply(strsplit(file.list,'_'),'[[',2)
  levels(factor(projects))
}
