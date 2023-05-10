#' Creates a maker file inside the data-raw folder
#'
#' @description
#' Creates template files that help create data sets; several
#' data set makers are supported; use no arguments to see the
#' interactive menu.
#'
#' @param fileMaker type of file to generate, if \code{NULL} options are provided via terminal
#'
#' @importFrom utils menu
#'
#' @examples
#' \dontshow{
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
# save the AFM data into a database

library(tidyverse)
library(RAWdataR)
library(nanoAFMr)
library(DBI)
verbose = TRUE

# dataAFM.filenameSQL is set in zzz.R
if (verbose) cat('AFM SQL dbname:', dataAFM.filenameSQL)

# find all AFM files, then add them to the SQL DB
dataRAW %>%
  filter(type == 'AFM') %>%
  filter(missing == FALSE) %>%
  mutate(fname = file.path(path, filename)) %>%
  select(ID, fname) -> fileList

if (verbose) cat('Found', nrow(fileList), 'AFM files.\\n')

mydb <- dbConnect(RSQLite::SQLite(), dataAFM.filenameSQL)
# which AFM images are already saved?
tbList <- dbListTables(mydb)
savedIDs = c()
if ('afmData' %in% tbList) {
  tb1 = dbGetQuery(mydb, 'SELECT ID FROM afmData')
  savedIDs = tb1$ID
}
if (verbose) cat('Will update DB only; . = added, - = skipped, X = error\\n')

for(i in 1:nrow(fileList)) {
  if (i %% 40 == 0) cat('\\n')
  # check whether file is already in DB
  ID = fileList$ID[i]
  if (ID %in% savedIDs) {
    cat('-')
    next
  }
  # get filename
  afmFile = fileList$fname[i]

  # try loading the AFM image
  try({ a = NULL; a = AFM.import(afmFile) })
  if (is.null(a)) { cat('X') }
  else {
    AFM.writeDB(a, mydb, ID, verbose=FALSE)
    cat('.')
  }
}
cat('\\n')

DBI::dbDisconnect(mydb)

if (verbose) cat('Saved AFM images in database:', dataAFM.filenameSQL,'\\n')
"

codeZZZ = "
.onLoad <- function(libname, pkgname) {
  dataAFM.filenameSQL <<- paste0(pkgname, '_',
                                as.character(packageVersion('dataAhir')),
                                '.sqlite'')
  RAWfolder <<- 'RAW''
  repoURL <- 'https://www.REPLACE.com/repo'
  if (!file.exists(dataAFM.filenameSQL)) {
    # try to download it
    sourceURL = paste0(repoURL,dataAFM.filenameSQL)

    # determine if file is found
    con <- url(sourceURL)
    check <- suppressWarnings(try(open.connection(con,open='rt',timeout=2),silent=T)[1])
    suppressWarnings(try(close.connection(con),silent=T))
    urlExists = ifelse(is.null(check),TRUE,FALSE)

    if(urlExists) {
      # download and save file
      cat('Found online SQL database; downloading data file now.\\n')
      download.file(url=sourceURL,destfile=dataAFM.filenameSQL, method='curl')
    } else {
      warning('SQL data file not found.')
    }
  }
  if (!dir.exists(RAWfolder)) cat('RAW folder is not found. Package for view only.\\n')
  cat('AFM SQL database:', dataAFM.filenameSQL,'\\n')

  invisible()
}
"
  codeSel = NULL
  if(is.null(fileMaker)) {
    switch(menu(c("dataRAW files",
                  "AFM data files",
                  "ZZZ file")) ,

           { codeSel = codeRAW; fileData='make.dataRAW.R' },
           { codeSel = codeAFM; fileData='make.dataAFM.R' },
           { codeSel = codeZZZ; fileData='zzz.R' })
  } else {
    codeSel = NULL
    fileData = fileMaker
    if (fileMaker=='make.dataRAW.R') codeSel = codeRAW
    else if (fileMaker=='make.dataAFM.R') codeSel = codeAFM
    else if (fileMaker=='zzz.R') codeSel = codeZZZ
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
