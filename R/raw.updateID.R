#' Assigns a Unique ID to each RAW Data File
#'
#' Finds all RAW files and assigns a unique ID. Once the ID is assigned,
#' it is immutable; each file is identified by its CRC check sum,
#' code and file size, so not by the file name; if the file name or location
#' has changed, the ID will remain the same, but the file name is updated.
#' Some meta data with paths to RAW data is stored as header information, currently
#' located at the end of the file.
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
#' @param f_post function to customize sample, type etc.
#' @param forceRegenerate logical, regenerate file, use with great care only
#' @param fixDuplicates logical, if \code{TRUE}, duplicates are removed, use with care only
#' @param removeIDs CAUTION: will delete IDs listed as vector
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
                         f_post = NA,
                         forceRegenerate = FALSE,
                         fixDuplicates = FALSE,
                         removeIDs = c(),
                         noData = FALSE,
                         verbose = TRUE) {
  # Get RAW-ID.csv File name and location
  fIDfile = raw.RAWIDfile(pRESULTS, idFile)
  if (verbose) cat("RAW ID File:", fIDfile,"\n")

  # Get path for RAW data
  if (pRAW == "") pRAW = raw.readRAWIDheader(fIDfile)$path
  if (pRAW == "" | (!dir.exists(pRAW))) pRAW = .promptRAWpath()


  # check if ID file already exists
  # -------------------------------
  ID <- 7     # lowest ID
  if (file.exists(fIDfile) & !forceRegenerate) {
    rID <- raw.readRAWIDfile(fIDfile)
    rID_list <- raw.readRAWIDheader(fIDfile)

    if (verbose) cat("Found",nrow(rID),'IDs in IDfile.\n')
    if ('IDmax' %in% names(rID_list)) {
      ID = as.numeric(rID_list$IDmax) + 1
    } else {
      if (nrow(rID)>0) ID = max(rID$ID) + 1
    }
  } else {
    if ( (forceRegenerate) & (interactive()) ) {
      a = readline(prompt="Are you sure to delete RAW-ID.csv (yes/NO):")
      if (tolower(a) != 'yes') stop("Call raw.updateID() with forceRegenerate=FALSE.")
    }
    if (verbose) cat("Will create a brand-new data file.\n")

    rID <- data.frame()
    rID_list <- list(pgm = "RAWdataR", path = pRAW, paths = c())
  }

  # check if any files are missing or have changed:
  if(nrow(rID)>0) {
    # check all files for changes
    for(j in 1:nrow(rID)) {
      fname = file.path(rID$path[j], rID$filename[j])
      if (file.exists(fname)) {
        crc = .getCRC(fname)
        if (crc != rID$crc[j]) {
          if (verbose) cat("Content in file ", rID$filename[j], " has changed! Making new ID.\n")
          # file name is the same, but different CRC code; therefore, either the file was
          # altered, or the same file name is used for a different data set: therefore, maintain
          # the old ID as a missing file, then create a new ID for this file.
          rID$missing[j] = TRUE
          r <- .addFile(fname, ID, pRAW)
          if (!(crc %in% rID$crc)) {
            # add the file as a new file
            r$altered = TRUE
            ID <- ID + 1
            rID <- rbind(rID, r)
          } else {
            # CRC is found elsewhere
            j2 <- which(rID$crc == crc)[1]
            if (fname != file.path(rID$path[j2], rID$filename[j2])) rID[j2,] = r
          }
        }
      } else {
        # filename is not found anymore, declare missing
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
  if (verbose) cat("--> Updating / adding new files from",pRAW,".\n")
  file.list = dir(pRAW, recursive = TRUE)
  file.list = file.path(pRAW, file.list)
  if (verbose) cat("Found",length(file.list),'files in RAW folder.\n')

  for(f in file.list) {
    # if it is a directory, then do not add
    if (dir.exists(f)) next;

    # add the file
    r <- .addFile(f, ID, pRAW)

    # check if file already has an ID
    if (nrow(rID)>0) {
      if (r$crc %in% rID$crc) {
        # check if the file name is the same
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
            warning("CRC matches, but file size differs in file:",f)
            # rare case: crc matches, but file size different
            rID = rbind(rID, r)
            ID = ID + 1
          }
        } # end FOR
      } else {
        # CRC is not in RAW-ID, so add it:
        rID = rbind(rID, r)
        ID = ID + 1
      }
    } else {
      # first ID to add
      rID = r
      ID = ID + 1
    }

  }

  # CUSTOMIZE with post function
  if (is(f_post,"function")) rID <- f_post(rID)

  # UPDATE header information
  # ----------------------------
  rID_list$version = packageVersion("RAWdataR")
  rID_list$pgm = "RAWdataR"
  rID_list$stamp = Sys.time()
  rID_list$path = pRAW
  if (!(pRAW %in% rID_list$paths)) rID_list$paths = c(pRAW, rID_list$paths)
  rID_list$IDmax = ID
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
  rID$path = gsub("^/+","/",rID$path)

  # SAVE RAW ID File
  # ----------------------------
  if (verbose) cat("Writing RAW ID file: ",fIDfile,"\nTable:\n")
  if (verbose) print(rID)
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

.promptRAWpath <- function() {
  if (!interactive()) stop("Provide pRAW argument in raw.updateID().")
  while(TRUE) {
    pRAW = readline(prompt="Enter path with RAW data: ")
    if (pRAW == "") stop("Need a RAW location folder to proceed.")
    if (dir.exists(pRAW)) break
    cat("RAW data folder not found.\n")
  }
}

.addFile <- function(f, ID, pRAW) {
  r = data.frame(
    ID = ID,
    path = gsub(pRAW,'',dirname(f)),
    filename = basename(f),
    crc = .getCRC(f),
    size = file.info(f)$size,
    type = .getFileType(f),
    missing = !file.exists(f),
    altered = FALSE,
    sample = "",
    date = format(file.info(f)$atime),
    meta = ""
  )
  if (is.na(r$crc)) stop("Cannot generate MD5 check sum for file:",f)

  r
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

