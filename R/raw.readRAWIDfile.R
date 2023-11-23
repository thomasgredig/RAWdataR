#' Reads an RAW ID file
#'
#' Ignores header / comment lines with #
#'
#' @param fIDfile file name, usually RAW_ID.csv
#'
#' @importFrom utils read.csv
#' @importFrom stats runif setNames
#'
#' @export
raw.readRAWIDfile <- function(fIDfile) {
  df <- read.csv(fIDfile, comment.char = "#")

  # read header information
  df_header <- raw.readRAWIDheader(fIDfile)
  # check, whether columns need to be updated
  if (df_header$version < "1.1") {
    # need to update to later version:
    df$date = ""
    df$meta = ""
  } else {
    df$path = file.path(df_header$path, df$path)
  }

  df
}


