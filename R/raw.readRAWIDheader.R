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
raw.readRAWIDheader <- function(fIDfile) {
  df <- read.csv(fIDfile)

  h <- df[grep("^#",df$ID),'ID']
  h <- trimws(gsub('^#','',h))
  header = setNames(as.list(trimws(sapply(strsplit(h,":"),'[[',2 ))),
               trimws(sapply(strsplit(h,":"),'[[',1 )))

  header
}
