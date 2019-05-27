#' returns the username from the path name
#'
#' @param pfad path to the RAW folder
#' @return username
#' @examples
#' raw.getUsername('Research-User')
#'
#' @export
raw.getUsername <- function(pfad) {
  gsub('.*Research-(.*)?/.*','\\1',pfad)
}
