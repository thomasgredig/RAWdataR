#' Find all project names
#'
#' find all project names in a given directory
#'
#' @param pfad path to the RAW folder
#' @return vector with project names
#' @examples
#' raw.getNamesProjects(raw.getSamplePath())
#'
#' @export
raw.getNamesProjects <- function(pfad) {
  file.list = raw.getValidFiles(pfad)
  projects = sapply(strsplit(file.list,'_'),'[[',2)
  levels(factor(projects))
}
