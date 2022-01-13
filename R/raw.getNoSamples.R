#' returns approximate number of samples that were made
#'
#' @param pfad path to the RAW folder
#' @param recursive if \code{TRUE} search also subfolders
#' @return number of samples that were made with the NTE
#' @examples
#' raw.getNoSamples(raw.getSamplePath())
#'
#' @export
raw.getNoSamples <- function(pfad, recursive=FALSE) {
  q = raw.inspectFolder(pfad, recursive=recursive)
  length(strsplit(q$samples,",")[[1]])
}
