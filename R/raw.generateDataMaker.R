#' creates a maker file inside the data-raw folder
#'
#'
#' @export
raw.generateDataMaker <- function(fileMaker = 'make.dataRAW.R') {

codeMaker = "
## code to prepare RAW_ID data set
library(dplyr)
library(RAWdataR)
verbose = TRUE

raw.updateID('RAW','data-raw', verbose=TRUE)
dataRAW <- read.csv('data-raw/RAW-ID.csv')
dataRAW$path = gsub('.*\\/RAW/','',dataRAW$path)
dataRAW$sample = gsub('.*([A-Z][A-Z]\\d{6}[A-Z]*).*','\\1', dataRAW$filename)

m = grep('png$', dataRAW$filename)
dataRAW$type[m] = 'image'

m = grep('\\.R$', dataRAW$filename)
dataRAW$type[m] = 'R'

m = grep('\\.xlsx$', dataRAW$filename)
dataRAW$type[m] = 'Excel'

m = grep('^RAW-ID', dataRAW$filename)
dataRAW$type[m] = 'RAW-ID'

if (verbose) names(dataRAW)

usethis::use_data(dataRAW, overwrite = TRUE)
dRAW = sinew::makeOxygen('dataRAW', add_fields = 'source')

fileConn<-file('R/dataRAW.R','wt')
writeLines(dRAW, fileConn)
close(fileConn)
"

  fInit = file.path('data-raw',fileMaker)
  if (!file.exists(fInit)) {
    fileConn<-file(fInit,"wt")
    writeLines(codeMaker, fileConn)
    close(fileConn)
  } else {
    warning(paste(fInit, "already exists; will not overwrite."))
  }


}
