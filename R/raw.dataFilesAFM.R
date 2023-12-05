#' Create dataFilesAFM Table
#'
#' @param fIDfile RAW-ID file with path
#' @param dataFilesAFM table with the AFM data
#' @param f_post function to customize sample, type etc.
#' @param verbose logical for extra information
#'
#' @importFrom dplyr "%>%" filter
#' @importFrom nanoAFMr AFM.import AFMinfo AFMinfo.item AFM.partial
#'
#' @export
raw.dataFilesAFM <- function(fIDfile = 'data-raw/RAW-ID.csv',
                             dataFilesAFM = NULL,
                             f_post = NA,
                             verbose=FALSE) {
  if (!file.exists(fIDfile)) stop("Cannot find RAW-ID file.")
  dataRAW <- raw.readRAWIDfile(fIDfile)
  # Find AFM images that could be added
  dataRAW %>% filter(missing == FALSE) %>%
    filter(type == 'AFM') -> rFile
  if (verbose) cat("Found",nrow(rFile),"AFM images.\n")

  # Add any AFM file data that already exists
  if (length(dataFilesAFM)==0) {
    result = data.frame()
  } else {
    result = dataFilesAFM
    if (verbose) cat("Already",nrow(result),"AFM images in dataFilesAFM\n")
  }

  ###########
  for(j in 1:nrow(rFile)) {
    # check if AFM file needs to be loaded and added
    if (length(dataFilesAFM) > 0) { if (rFile$ID[j] %in% dataFilesAFM$ID) next }

    fname = file.path(rFile$path[j], rFile$filename[j])
    if (verbose) cat("Adding:",basename(fname),"\n")

    df     <- AFM.import(fname)
    dfInfo <- AFMinfo(fname)
    note   <- AFMinfo.item(dfInfo, 'Note')
    scanRate      <- dfInfo$scanRate.Hz
    cantilever    <- AFMinfo.item(dfInfo,"cantilever")
    setPoint      <- AFMinfo.item(dfInfo, "Setpoint")
    scanAngle     <- AFMinfo.item(dfInfo,"ScanAngle")
    driveFrequency <- AFMinfo.item(dfInfo,"DriveFrequency")

    res.px = as.numeric(gsub('(\\d+).*','\\1',summary(df)$resolution))
    size.nm = as.numeric(gsub('(\\d+).*','\\1',summary(df)$size))

    r = cbind(
      ID = rFile$ID[j],
      sample = rFile$sample[j],
      filename = rFile$filename[j],
      partial = AFM.partial(df),
      note = note,
      quality = "",
      scanRate = scanRate,
      cantilever = cantilever,
      setPoint = setPoint,
      scanAngle = scanAngle,
      driveFrequency = driveFrequency,
      summary(df)[1,],
      res.px = res.px[1],
      size.nm = size.nm[1]
    )
    r$channel = paste(summary(df)$channel, collapse=",")
    r$z.min = paste(summary(df)$z.min, collapse=",")
    r$z.max = paste(summary(df)$z.max, collapse=",")
    r$z.units = paste(summary(df)$z.units, collapse=",")
    r$imgNo = 0
    r$direction = ""
    r$history <- NULL

    result = rbind(result, r)
  }

  # Number of the image for the run
  result$imgNo = as.numeric(gsub('.*(\\d{3})\\.?.*','\\1',result$filename))

  # Scanning Direction of AFM run
  result$direction = 0
  result$direction[which(grepl('Forward', result$filename)==TRUE)] = 1
  result$direction[which(grepl('Backward', result$filename)==TRUE)] = -1

  # CUSTOMIZE with post function
  if (is(f_post,"function")) result <- f_post(result)

  result
}
