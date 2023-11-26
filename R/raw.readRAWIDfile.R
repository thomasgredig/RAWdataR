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
raw.readRAWIDfile <- function(fIDfile = 'data-raw/RAW-ID.csv') {
  if (!file.exists(fIDfile)) return(data.frame())
  df <- read.csv(fIDfile, comment.char = "#")
  # convert NA back to empty strings
  df[is.na(df)]=""

  # read header information
  df_header <- raw.readRAWIDheader(fIDfile)
  # check, whether columns need to be updated
  if (df_header$version < "1.1") {
    # need to update to later version:
    df$date = ""
    df$meta = ""
  } else {
    df$missing = TRUE
    for(j in 1:length(df_header$paths)) {
      p <- df_header$paths[j]
      if (dir.exists(p)) {
        # check if any missing files are part of this path?
        for(i in 1:nrow(df)) {
          if (df$missing[i]) {
            # if (is.na(df$path[i])) df$path[i] = ""
            # print(file.path(p, df$path[i], df$filename[i]))
            if (file.exists(file.path(p, df$path[i], df$filename[i]))) {
              df$path[i] = file.path(p, df$path[i])
              df$missing[i] = FALSE
            }
          }
        }
      }
    }
  }

  df
}


