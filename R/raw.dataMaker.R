#' creates a maker file inside the data-raw folder
#'
#' The
#'
#' @param fileMaker type of file to generate, if \code{NULL} options are provided via terminal
#'
#' @importFrom utils menu
#'
#' @example
#' \donotrun{
#' raw.dataMaker()
#' }
#' @export
raw.dataMaker <- function(fileMaker = NULL) {

codeRAW = "
## code to prepare RAW_ID data set
library(dplyr)
library(RAWdataR)
verbose = TRUE

raw.updateID('RAW','data-raw', verbose=TRUE)
dataRAW <- read.csv('data-raw/RAW-ID.csv')
dataRAW$path = gsub('.*/RAW/','',dataRAW$path)
dataRAW$sample = gsub('.*([A-Z][A-Z]\\\\d{6}[A-Z]*).*','\\\\1', dataRAW$filename)

# m = grep('png$', dataRAW$filename)
# dataRAW$type[m] = 'image'

if (verbose) names(dataRAW)

usethis::use_data(dataRAW, overwrite = TRUE)
dRAW = sinew::makeOxygen('dataRAW', add_fields = 'source')

fileConn<-file('R/dataRAW.R','wt')
writeLines(dRAW, fileConn)
close(fileConn)
"

codeAFM = "
library(dplyr)
library(nanoscopeAFM)
library(RAWdataR)
verbose = TRUE

# 1. Find Image Files
# ===========================
raw.updateID('RAW','data-raw', verbose=TRUE)
dataRAW %>% filter(type=='AFM' & missing==FALSE) -> rFile
if (verbose) print(paste('Found: ', nrow(rFile), 'AFM images.'))

getDirection <- function(filename) {
  s = ''
  if (grepl('Backward', filename)) s= 'Backward'
  if (grepl('Forward', filename)) s = 'Forward'
  s
}


# 2. Make Data File Table
# ==========================
result = data.frame()
for(j in 1:nrow(rFile) ) {
  fname = file.path(rFile$path[j], rFile$filename[j])
  d = AFM.import(fname)

  result = rbind(result, data.frame(
    ID = rFile$ID[j] ,
    sample = rFile$sample[j],
    direction = getDirection(rFile$filename[j]),
    imageNo = as.numeric(gsub('.*\\\\_(\\\\d{3})\\\\..*','\\\\1', rFile$filename[j])),
    summary(d)
  ))
}
result$history <- NULL

# 3. Select high quality images
# ==========================
afmIDs = c(8, 12, 15)
result$quality = ''
result$quality[which(result$ID %in% afmIDs)] = 'high'

# 4. Save Data Table to DB
# ==========================
dataFilesAFM = result
usethis::use_data(dataFilesAFM, overwrite = TRUE)


# 5. Gather AFM data
# ==========================
dataRAW %>% filter(ID %in% afmIDs) -> rFile
afmd = list()
for(j in 1:nrow(rFile) ) {
  fname = file.path(rFile$path[j], rFile$filename[j])
  d = AFM.import(fname)
  afmd[[rFile$ID[j]]] = AFM.selectChannel(d, 1)
}


# 6. Save AFM files to DB
# ==========================
dataAFM = afmd
usethis::use_data(dataAFM, overwrite = TRUE)
"
  if(is.null(fileMaker)) {
    switch(menu(c("dataRAW files", "AFM data files")) + 1,
           codeSel = NULL,
           { codeSel = codeRAW; fileData='make.dataRAW.R' },
           { codeSel = codeAFM; fileData='make.dataAFM.R' })
  } else {
    codeSel = NULL
    if (fileMaker=='make.dataRAW.R') codeSel = codeRAW
    else if (fileMaker=='make.dataAFM.R') codeSel = codeAFM
  }

  if (!is.null(codeSel)) {
    fInit = file.path('data-raw',fileData)
    if (!file.exists(fInit)) {
      fileConn<-file(fInit,"wt")
      writeLines(codeSel, fileConn)
      close(fileConn)
    } else {
      warning(paste(fInit, "already exists; will not overwrite."))
    }
  }

}
