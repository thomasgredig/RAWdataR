#' Fix invalid filename
#'
#' @param filename name of file
#' @param instrument new name of instrument
#' @return returns fixed filenames
#' @examples
#' f = raw.findFiles(raw.getSamplePath(), instrument='MM160622SI1')
#' print(f)
#' raw.fixInvalidFile(f, instrument='vsm')
#' @export
raw.fixInvalidFile <- function(filename, instrument='') {
  p = dirname(filename)
  f = basename(filename)
  if (nchar(instrument)>0) {
    f = gsub('^(.*?_.*?_.*?)_(.*)$','\\1_vsm_\\2',f)
  }
  file.path(p,f)
}
