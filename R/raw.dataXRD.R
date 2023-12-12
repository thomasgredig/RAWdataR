#' Create dataXRD Table
#'
#' @param fIDfile RAW-ID file with path
#' @param dataFilesAFM table with the AFM data
#' @param verbose logical for extra information
#'
#' @importFrom dplyr "%>%" filter group_by summarize
#' @importFrom rigakuXRD xrd.import
#' @importFrom nanoAFMr AFM.import AFMinfo AFMinfo.item AFM.partial
#'
#' @export
raw.dataXRD <- function(fIDfile = 'data-raw/RAW-ID.csv',
                             dataXRD = NULL,
                             verbose=FALSE) {

  if (!file.exists(fIDfile)) stop("Cannot find RAW-ID file.")
  dataRAW <- raw.readRAWIDfile(fIDfile)

  # filter out parsed XRD data files
  if (!is.null(dataXRD)) if (nrow(dataXRD)==0) dataXRD=NULL
  if (is.null(dataXRD)) {
    ID.exclude = c()
    r = data.frame()
    df.xrd <- data.frame()
  } else {
    dataXRD %>% group_by(ID) %>% summarize() -> df.xrd
    ID.exclude = df.xrd$ID
    r <- dataXRD
  }

  # define NOT IN operator
  `%notin%` <- Negate(`%in%`)

  # select XRD data files
  dataRAW %>% filter(missing == FALSE) %>%
    filter(type=='XRD' | type=='XRR') -> fileList
  if (nrow(df.xrd)>0)
    fileList <- fileList %>% filter(ID %notin% df.xrd$ID)
  if (verbose) print(paste("Found",nrow(fileList),"XRD / XRR files."))
  if (nrow(fileList)==0) return(r)

  # read all data and generate dataXRD object
  # update with data from new files
  for(n in 1:nrow(fileList)) {
    filename = file.path(fileList$path[n], fileList$filename[n])

    if (grepl('ras$',filename)) next
    d =  xrd.import(filename)

    d$ID = fileList$ID[n]
    r = rbind(r,d)
  }

  r
}
