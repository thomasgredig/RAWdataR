#' Creates a maker file inside the data-raw folder
#'
#' @description
#' Creates template files that help create data sets; several
#' data set makers are supported; use no arguments to see the
#' interactive menu.
#'
#' @importFrom utils menu
#'
#' @examples
#' \dontrun{
#' raw.dataMaker()
#' }
#'
#' @export
raw.dataMaker <- function( ) {
  if (!interactive()) { warning("Use interactive mode."); return(NULL) }
  switch(menu(c("makeData(): updates the RAW-ID.csv",
                "getAFMdbName(): finds the database",
                "zzz(): starter message")) ,

         { fileData='makeData.R' },
         { fileData='getAFMdbName.R' },
         { fileData='zzz.R' })

  fSource <- system.file("extdata",fileData,package='RAWdataR')
  cat("Loading:", fSource,"\n")
  if (!file.exists(fSource)) warning("Source file note found in raw.dataMaker().")


  fInit = file.path('R',fileData)
  if (!file.exists(fInit)) {
    file.copy(from = fSource, to=fInit)
    cat("Copied to:",fInit,"\n")
  } else {
    warning(paste(fInit, "already exists; will not overwrite."))
  }


}
