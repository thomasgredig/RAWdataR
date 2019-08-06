###################################
#
# (c) 2018 Thomas Gredig
#
# Date: 2018-11-07
#
# Take Inventory of all RAW files
# and which one's need to be fixed.
#
#
###################################

path.RESULTS = file.path('..','Results')
path.RAW = file.path('..','..','RAW')
library(tools)   # for MD5 sum

file.list = dir(path.RAW)
r = data.frame()
for(f in file.list) {
  fname = file.path(path.RAW, f)
  f.info = file.info(fname)
  y1 = strsplit(f,'\\.')[[1]]
  file.ext = toupper(y1[length(y1)])
  if (!is.na(as.numeric(file.ext))) { file.ext = 'AFM'}
  r = rbind(r,
            data.frame(
              name = file.path(path.RAW, f),
              extension = file.ext,
              parts = length(strsplit(f, '-')[[1]]),
              size = f.info$size,
              mdate = f.info$mtime,
              cdate = f.info$ctime,
              md5 = md5sum(fname),
              dup = FALSE
              )
  )
}
r$name = as.character(levels(r$name)[r$name])
r=na.omit(r)

# find duplicates
ndup = which(duplicated(r$md5)==TRUE)
r$delete = FALSE
r$delete[ndup] = TRUE
r$dup[which(r$md5 %in% r$md5[ndup])] = TRUE

# sort through each duplicate and determine which to keep
for(i in ndup) {
  qdup = which(r$md5 ==  r[i,'md5'])
  nlen = nchar(r[qdup,'name'])
  if (nlen[2]>nlen[1]) {
    # keep qdup[2]
    r$delete[qdup[2]] = FALSE
    r$delete[qdup[1]] = TRUE
  } else {
    # keep qdup[1]
    r$delete[qdup[1]] = FALSE
    r$delete[qdup[2]] = TRUE
  }

}

# is it a readme file? then don't delete
r$delete[which(grepl('README',r$name)==TRUE)] = FALSE

# check files with the name "copy", those should be deleted first
ndup.copy = which(grepl('COPY',r$name,ignore.case=TRUE)==TRUE)
for(i in ndup.copy) {
  # check if "copy" is already being deleted
  if (r$delete[i]==FALSE) {
    qdup = which(r$md5 ==  r[i,'md5'])
    r$delete[qdup] = FALSE
    r$delete[i] = TRUE
  }
}

# remove files that are too small, under 200 bytes
r$delete[which(r$size<200)] = FALSE

# save data
write.csv(r, file = file.path(path.RESULTS,paste('all-raw-files-',Sys.Date(),'.csv',sep='')),
          row.names = FALSE)
levels(r$extension)

