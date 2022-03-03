#' Return path up one directory
#'
#' @param p path
#' @return path with last directory removed
#' @examples
#' path.goUpOneDir('/Users/test/fish-100')
#' @export
path.goUpOneDir <- function(p) {
  gsub('(.*)(//?[^//]+)$','\\1',p)
}
