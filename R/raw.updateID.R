#' Assigns a Unique ID to Each RAW Data File
#'
#' Code finds all RAW files and assigns a unique ID. Once the ID is assigned,
#' it is immutable; each file is identified by its CRC check sum,
#' code and file size, so not by the file name; if the file name
#' has changed, the ID will remain the same, and the file name is updated.
#'
#' @section
#' Possible scenarios:
#' \describe{
#'   \item{\code{(rule 1)}}{ RAW ID file does not exist and must be generated}
#'   \item{\code{(rule 2)}}{ new RAW file is added,}
#'   \item{\code{(rule 3)}}{ RAW file is missing,}
#'   \item{\code{(rule 4)}}{ RAW file has duplicate in different folder,}
#'   \item{\code{(rule 5)}}{ RAW file has duplicate with new name,}
#'   \item{\code{(rule 6)}}{ RAW file moved to a different folder, and folder needs update}
#' }
#'
#' @param pRAW path with raw data, if missing, then will prompt for path
#' @param pRESULTS path for results, default: uses pRAW
#' @param idFile name of file with IDs, default: RAW-ID.csv
#' @param forceRegenerate logical, regenerate file, use with great care only
#' @param fixDuplicates logical, if \code{TRUE}, duplicates are removed, use with care only
#' @param noData logical, if \code{TRUE}, returns RAW ID file name otherwise RAW data
#' @param verbose logical, if \code{TRUE} outputs information about the process
#'
#'
#' @return returns \code{TRUE} if name has a valid format
#'
#' @seealso \code{\link{raw.getFileByID}}, \code{\link{raw.getIDbyFile}}
#' @examples
#' \dontrun{
#'   raw.updateID()
#' }
#' @export
raw.updateID <- function(pRAW = "",
                         pRESULTS = 'data-raw',
                         idFile = 'RAW-ID.csv',
                         forceRegenerate = FALSE,
                         fixDuplicates = FALSE,
                         removeIDs = c(),
                         noData = FALSE,
                         verbose = TRUE) {
  # name for file that stores the RAW IDs
  fIDfile = file.path(pRESULTS, idFile)
  if (verbose) cat("RAW ID File:", fIDfile,"\n")
  # use the last entered path, if not specified
  if (pRAW == "") pRAW = raw.readRAWIDheader(fIDfile)$path

  # if no RAW folder is defined, then ask to enter:
  if (pRAW == "" | (!dir.exists(pRAW))) {
    c=0; while(c<9) {
      pRAW = readline(prompt="Enter path with RAW data: ")
      if (dir.exists(pRAW)) break
      cat("RAW data folder not found.\n")
      c=c+1
    }
  }


  # check if ID file already exists
  # -------------------------------
  ID <- 7     # lowest ID
  if (file.exists(fIDfile) & !forceRegenerate) {
    rID <- raw.readRAWIDfile(fIDfile)
    rID_list <- raw.readRAWIDheader(fIDfile)

    if (verbose) cat("Found",nrow(rID),'IDs in IDfile.\n')
    if (nrow(rID)>0) ID = max(rID$ID) + 1
  } else {
    if (verbose) cat("No IDs found, will create a brand-new data file.\n")

    rID <- data.frame()
    rID_list <- list(pgm = "RAWdataR", path = pRAW, paths= c())
  }

  # check if any files are missing or have changed:
  if(nrow(rID)>0) {
    # check all files for changes
    for(j in 1:nrow(rID)) {
      fname = file.path(rID$path[j], rID$filename[j])
      if (file.exists(fname)) {
        crc = .getCRC(fname)
        if (crc != rID$crc[j]) {
          if (verbose) cat("File ", rID$filename[j], " had changed content! Making new ID.\n")
          # file has changed, make new ID ?
          rID$altered[j] = TRUE
          rID$size[j] = file.info(fname)$size
          rID$crc[j] = crc  # update new CRC code
        }
      } else {
        rID$missing[j] = TRUE
      }
    }
    ## remove duplicates??
    if (fixDuplicates) {
      m1 = which(duplicated(rID$crc)==TRUE)
      if (length(m1)>0) {
        if (verbose) cat("Removing duplicated ", length(m1)," files.\n")
        rID <- rID[-m1,]
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
      path = gsub(pRAW,'',dirname(f)),
      filename = basename(f),
      crc = .getCRC(f),
      size = file.info(f)$size,
      type = .getFileType(f),
      missing = FALSE,
      altered = FALSE,
      sample = "",
      date = format(file.info(f)$atime),
      meta = ""
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
            if (is.na(rID$path[m])) rID$path[m] = ""
            if (is.na(r$path)) r$path = ""
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

  # UPDATE header information
  # ----------------------------
  rID_list$version = packageVersion("RAWdataR")
  if (!(pRAW %in% rID_list$paths)) rID_list$paths = c(pRAW, rID_list$paths)
  rID_list$path = pRAW
  # ----------------------------

  if (length(removeIDs)>0) {
    m <- which(rID$ID %in% removeIDs)
    if (length(m)>0) {
      if (verbose) cat("Removing:",length(m),"IDs.\n")
      rID <- rID[-m, ]
    }
  }

  # CLEAN UP Paths
  # ----------------------------
  for(p in rID_list$paths) {
    rID$path = gsub(paste0("^",p),"",rID$path)
  }

  # SAVE RAW ID File
  # ----------------------------
  if(nrow(rID)>0) raw.writeRAWIDfile(rID, rID_list, fIDfile = fIDfile)

  if (noData) {
    result = fIDfile
  } else {
    result <- raw.readRAWIDfile(fIDfile)
  }
  invisible(result)
}




#' Return filename by ID
#'
#' @param ID list of RAW file IDs
#' @param pRESULTS results folder
#' @param idFile name of the file the the RAW IDs
#' @returns data frame with filename, path, and other information about the file
#'
#' @seealso \code{\link{raw.getIDbyFile}}, \code{\link{raw.updateID}}
#'
#' @export
raw.getFileByID <- function(ID,
                            pRESULTS = 'data-raw',
                            idFile = 'RAW-ID.csv') {

  # name for file that stores the RAW IDs
  fIDfile = file.path(pRESULTS, idFile)
  if(!file.exists(fIDfile)) return(NULL)

  rID = raw.readRAWIDfile(fIDfile)
  m = which(rID$ID %in% ID)
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
  if (grepl('\\_XRR',f)) type = "XRR"
  if (grepl('\\_AMR',f)) type = "AMR"
  if (grepl('\\_FMR',f)) type = "FMR"
  if (grepl('\\_AFM',f)) type = "AFM"
  if (grepl('\\_EDS',f)) type = "EDS"
  if (grepl('\\_SEM',f)) type = "SEM"
  if (grepl('\\_Rxx',f)) type = "AMR"
  if (grepl('\\_DAT',f)) type = "VSM"

  if (type=="") {
    f = tools::file_ext(filename)
    if (grepl('nid',f)) type = 'AFM'
    if (grepl('ras[x]*',f)) type = 'XRD'
    if (grepl('ibw',f)) type = 'AFM'
    if (grepl('tiff',f)) type = 'AFM'
    if (grepl('\\d{3}',f)) type = 'AFM'
    if (grepl('csv',f)) type = 'table'
  }

  type
}

