#' Reads an RAW ID header
#'
#' Header information is preseded by # and separated name:value with colon
#' for example # Version: 1.0
#'
#' @importFrom utils read.csv
#'
#' @examples
#' pRAW = makeRAWtestFolder()
#' raw.readRAWIDheader(file.path(pRAW, "RAW-ID.csv"))
#'
#' @export
raw.readRAWIDheader <- function(fIDfile = 'data-raw/RAW-ID.csv') {
  # return empty path if RAW ID file is not found.
  if (!file.exists(fIDfile)) {
    header = list(path="")
    return(header)
  }

  df <- read.csv(fIDfile)
  h <- df[grep("^#",df$ID),'ID']
  if (is.integer(h)) return(list(version="0.1"))

  h <- trimws(gsub('^#','',h))
  header = setNames(as.list(trimws(sapply(strsplit(h,":"),'[[',2 ))),
               trimws(sapply(strsplit(h,":"),'[[',1 )))

  # un-serialize vectors
  for(keys in names(header)) {
    v = header[[keys]]
    if (grepl(";",v)) {
      header[[keys]] <- strsplit(v,";")[[1]]
    }
  }


  header
}
