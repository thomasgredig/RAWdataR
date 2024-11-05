#' Initialize R package with RAW data concept
#'
#' @importFrom here here
#' @importFrom usethis use_data_raw
#'
#' @export
raw.init <- function() {
  cat("Initializing Data Package with RAW package.\n\n")

  # check whether data-raw folder already exists,
  # if it exists, then abort with message that
  # initialization can only be run once.
  if (dir.exists(here::here('data-raw'))) {
    cat("Abort: Initialization cannot be performed. data-raw folder already exists.")
    warning("Remove data-raw folder to initialize.")
  }

  # create the data-raw folder
  usethis::use_data_raw('dataRAW')
}
