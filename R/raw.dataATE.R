#' Create dataATE Table
#'
#' @param fIDfile RAW-ID file with path
#' @param dataATE table with the ATE data
#' @param verbose logical for extra information
#'
#' @importFrom dplyr "%>%" filter select
#' @importFrom angstromATE ATE.info
#'
#' @export
raw.dataATE<- function(fIDfile = 'data-raw/RAW-ID.csv',
                             dataATE = NULL,
                             verbose=FALSE) {
  if (!file.exists(fIDfile)) stop("Cannot find RAW-ID file.")
  dataRAW <- raw.readRAWIDfile(fIDfile)
  if (nrow(dataRAW)==0) return(NULL)

  df <- dataRAW %>% filter(type=='ATE') %>% select(ID, missing, path, filename)
  if (nrow(df)==0) return(NULL)

  r = data.frame()
  for(j in 1:nrow(df)) {
    if (df$missing[j]) next
    fname = file.path(df$path[j], df$filename[j])
    if(grepl('json$',fname)) next
    if(grepl('xml$',fname)) next
    if(!file.exists(fname)) next

    r1 = ATE.info(fname)
    if (length(r1)==0) next
    r1$ID = df$ID[j]
    r = rbind(r, r1)
  }

  r
}
