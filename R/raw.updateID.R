#' Assigns ID to each RAW data file
#'
#' Code finds all RAW files and assigns an ID, once the ID is assigned,
#' it should stay with that file; the file is identified by the CRC checksum
#' code and filesize, so not necessarily by the filename; if the filename
#' has changed, the ID will remain the same, but the file is changing
#'
#' @section
#' Possible scenarios:
#' (1) RAW ID file does not exist and must be generated
#' (2) new RAW file is added,
#' (3) RAW file is missing,
#' (4) RAW file has duplicate in different folder,
#' (5) RAW file has duplicate with new name,
#' (6) RAW file moved to a different folder, and folder needs update
#'
#' @param pRAW path with raw data
#' @param pRESULTS path for results
#' @param idFile name of file with IDs
#' @param forceRegenerate logical, regenerate file, use with great care only
#' @param fixDuplicates logical, if \code{TRUE}, duplicates are removed, use with care only
#' @param verbose logical, if \code{TRUE} outputs information about the process
#'
#'
#' @return returns \code{TRUE} if name has a valid format
#' @examples
#' if (FALSE) raw.updateID(path.RAW, path.RESULTS)
#'
#' @export
raw.updateID <- function(pRAW,
                         pRESULTS,
                         idFile = 'RAW-ID.csv',
                         forceRegenerate = FALSE,
                         fixDuplicates = FALSE,
                         verbose = FALSE) {
  if(missing(pRAW) & exists("path.RAW")) pRAW = path.RAW
  if(missing(pRESULTS) & exists("path.RESULTS")) pRESULTS = path.RESULTS

  # name for file that stores the RAW IDs
  fIDfile = file.path(pRESULTS, idFile)
  if (verbose) cat("RAW ID File:", fIDfile,"\n")

  # check if ID file already exists
  ID = 7
  if (file.exists(fIDfile) & !forceRegenerate) {
    rID = read.csv(fIDfile)
    ## Use this to randomly change the crc
    ## rID$crc = rID$crc + floor(runif(nrow(rID), min=0, max=2))
    if (verbose) cat("Found",nrow(rID),'IDs in IDfile.\n')
    if (nrow(rID)>0) ID = max(rID$ID) + 1
  } else {
    rID = data.frame()
  }

  # check if any files are missing or have changed:
  if(nrow(rID)>0) {
    ## remove duplicates??
    if (fixDuplicates) {
      m1 = which(duplicated(rID$crc)==TRUE)
      if (length(m1)>0) rID <- rID[-m1,]
    }
    for(j in 1:nrow(rID)) {
      fname = file.path(rID$path[j], rID$filename[j])
      if (file.exists(fname)) {
        crc = .getCRC(fname)
        if (crc != rID$crc[j]) {
          # file has changed, make new ID ?
          rID$altered[j] = TRUE
          rID$size[j] = file.info(fname)$size
          rID$crc[j] = crc  # update new CRC code
        }
      } else {
        rID$missing[j] = TRUE
      }
    }
  }
  if (verbose) cat("There are",length(which(rID$missing==TRUE)),"missing files.\n")
  if (verbose) cat("There are",length(which(rID$altered==TRUE)),"altered files.\n")


  # Files in the RAW folder
  file.list = dir(pRAW, recursive = TRUE)
  file.list = file.path(pRAW, file.list)
  if (verbose) cat("Found",length(file.list),'files in RAW folder.\n')


  for(f in file.list) {
    if (dir.exists(f)) next;

    r = data.frame(
      ID = ID,
      path = dirname(f),
      filename = basename(f),
      crc = .getCRC(f),
      size = file.info(f)$size,
      type = .getFileType(f),
      missing = FALSE,
      altered = FALSE,
      sample = ""
    )
    if (is.na(r$crc)) {
      warning(paste("Cannot generate MD5 for file:",f))
      next
    }

    # check if file already has an ID
    if(r$crc %in% rID$crc) {
      # check if the filename is the same
      m1 = grep(r$crc, rID$crc)
      for(m in m1) {
        if (r$size == rID$size[m]) {
          if (r$filename == rID$filename[m]) {
            if (r$path != rID$path[m]) {
              # path has changed, set to previous path
              rID$path[m] = r$path
              rID$missing[m] = FALSE
            } else {
              # path and filename are the same, do not add
            }
          } else {
            rID$filename[m] = r$filename
            rID$path[m] = r$path
            rID$missing[m] = FALSE
          }
        } else {
          # rare case: crc matches, but file size different
          rID = rbind(rID, r)
          ID = ID + 1
        }
      } # end FOR
    } else {
      rID = rbind(rID, r)
      ID = ID + 1
    }

  }
  if (nrow(rID)>0)  write.csv(rID, fIDfile, row.names = FALSE)

  rID
}

#' Return filename by ID
#'
#' @param ID list of RAW file IDs
#' @param pRESULTS results folder
#' @param idFile name of the file the the RAW IDs
#'
#' @seealso \code{\link{raw.getIDbyFile}}, \code{\link{raw.updateID}}
#'
#' @export
raw.getFileByID <- function(ID,
                            pRESULTS,
                            idFile = 'RAW-ID.csv') {
  if(missing(pRESULTS) & exists("path.RESULTS")) pRESULTS = path.RESULTS

  # name for file that stores the RAW IDs
  fIDfile = file.path(pRESULTS, idFile)
  if(!file.exists(fIDfile)) return(NULL)

  rID = read.csv(fIDfile)
  m = which(rID$ID %in% ID)
  rID[m,]
}


#' Return filename by ID
#'
#' @param file.list list of file names
#' @param pRESULTS results folder
#' @param idFile name of the file the the RAW IDs
#'
#' @seealso \code{\link{raw.getIDbyFile}}, \code{\link{raw.updateID}}
#'
#' @export
raw.getIDbyFile <- function(file.list,
                            pRESULTS,
                            idFile = 'RAW-ID.csv') {

  if(missing(pRESULTS) & exists("path.RESULTS")) pRESULTS = path.RESULTS

  # name for file that stores the RAW IDs
  fIDfile = file.path(pRESULTS, idFile)
  if(!file.exists(fIDfile)) {
    warning("Please run first raw.updateID() to generate RAW-ID file.")
    return(NULL)
  }

  rID = read.csv(fIDfile)
  # m = which(rID$filename %in% filename)
  # if (length(m)==0) return(data.frame(ID=0))
  m = c()
  for(f in file.list) {

    if (file.exists(f)) {
      crc = .getCRC(f)
      m1 = which(crc == rID$crc)
      if (length(m1)==0 | length(m1)>1) warning("Run raw.updatedID() first.")
    } else {
      fn = basename(f)
      m1 = which(fn == rID$filename)
      if (length(m1)==0 | length(m1)>1) warning("Run raw.updatedID() first.")
    }

    m = c(m, m1)
  }
  rID[m,]
}


NULL
# helper functions

.getCRC <- function(filename) {
  strtoi( raw.getMD5(filename, 7), base = 16 )
}

# returns file type
.getFileType <- function(filename) {
  type = ""
  f = basename(filename)
  if (grepl('\\_XRD',f)) type = "XRD"
  if (grepl('\\_AMR',f)) type = "AMR"
  if (grepl('\\_FMR',f)) type = "FMR"
  if (grepl('\\_AFM',f)) type = "AFM"
  if (grepl('\\_EDS',f)) type = "EDS"
  if (grepl('\\_SEM',f)) type = "SEM"
  if (grepl('\\_Rxxvs',f)) type = "AMR"

  type
}

