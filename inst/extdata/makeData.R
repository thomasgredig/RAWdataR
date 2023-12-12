#' Make Data Package
#'
#' Updates RAW files for the project. Use the `pRAW` folder argument to add data from
#' a particular folder. After updating the files, it will add the XRD data, then the
#' ATE thermal evaporator data, and any AFM data. High-quality AFM files will be saved to
#' the SQLite database.
#'
#' @param pRAW folder with RAW data, default will use last RAW folder or prompt user
#' @param overwrite logical to overwrite dataRAW, dataFilesAFM, etc. (use FALSE for dry run)
#' @param verbose logical, provides additional information
#'
#' @importFrom dplyr mutate "%>%" filter select
#' @importFrom RAWdataR raw.updateID raw.dataFilesAFM raw.dataXRD raw.dataATE
#' @importFrom nanoAFMr AFM.readRatings AFM.readDB
#'
#' @export
makeData <- function(pRAW = "", overwrite = TRUE, verbose=TRUE) {
  if (!overwrite) {
    print("Set overwrite = TRUE to overwrite files.")
  }

  f1 <- function(x) {
    m <- grep("png$", x$filename)
    x$type[m] <- "image"

    # check for ATE data files
    m <- grep("_Radak_", x$filename)
    x$type[m] <- "ATE"

    # extract sample name
    # ===================
    x$sample = gsub('.*([A-Z][A-Z]\\d{8}[A-Za-z0-9]*).*','\\1', x$filename)
    x$sample = gsub('.*(nanosurf.*?)\\_.*','\\1', x$filename)
    x
  }

  cat("\n\n==> re-generating dataRAW ...\n")
  dataRAW <- raw.updateID(pRAW = pRAW, f_post = f1, verbose=verbose)
  if (overwrite) usethis::use_data(dataRAW, overwrite = TRUE)

  cat("\n\n==> re-generating dataXRD ...\n")
  if (!exists('dataXRD')) dataXRD = NULL
  dataXRD <- raw.dataXRD(dataXRD = dataXRD, verbose=verbose)
  if (overwrite & nrow(dataXRD)>0) usethis::use_data(dataXRD, overwrite = TRUE)

  cat("\n\n==> re-generating dataATE ...\n")
  if (!exists('dataATE')) dataATE = NULL
  dataATE <- raw.dataATE(dataATE = dataATE)
  if (overwrite & !is.null(dataATE)) usethis::use_data(dataATE, overwrite = TRUE)

  cat("\n\n==> re-generating dataFilesAFM ...\n")
  if (!exists('dataFilesAFM')) dataFilesAFM = NULL
  dataFilesAFM <- raw.dataFilesAFM(dataFilesAFM = dataFilesAFM)
  if(file.exists(getAFMdbName())) {
    df <- AFM.readRatings(getAFMdbName(), meanValues = TRUE)
    IDs = df[df$quality==1,'ID']
    dataFilesAFM$quality[dataFilesAFM$ID %in% IDs] = 'high'
  }
  if (overwrite & nrow(dataFilesAFM)>0) usethis::use_data(dataFilesAFM, overwrite = TRUE)

  cat("\n\n==> adding files to AFM DB ...\n")
  if (!file.exists(getAFMdbName())) {
    # create DB
    #  Initialize SQL database
    dbSQL <- initAFMdb()
    cat("New database created at: ",dbSQL,"\n")
  }
  # adding AFM files to database
  dbSQL = getAFMdbName()

  rFile = dataFilesAFM %>% filter(quality == 'high')

  if (verbose) cat("Found", nrow(rFile),"high-quality AFM images.\n")
  mydb <- DBI::dbConnect(RSQLite::SQLite(), dbSQL)
  afmIDlist = AFM.readDB(mydb) # these IDs are already in the database

  rf = dataRAW %>% filter(ID %in% rFile$ID)
  if (nrow(rf)>0) {
    for(i in 1:nrow(rf)) {
      fileName = file.path(rf$path[i], rf$filename[i])
      if (file.exists(fileName)) {
        ID = rf$ID[i]
        if (ID %in% afmIDlist) { cat("x"); next }
        afmd = AFM.import(fileName)
        cat(".")
        AFM.writeDB(afmd, mydb, ID, verbose=TRUE)
      } else {

        warning("Cannot find file:", fileName)
      }
    }
  }

  DBI::dbDisconnect(mydb)
  cat("\n\n")


  return(TRUE)
}
