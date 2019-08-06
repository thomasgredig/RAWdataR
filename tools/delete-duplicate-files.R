###################################
#
# (c) 2018 Thomas Gredig
#
# Date: 2018-11-21
#
# DELETES DUPLICATE files (CAREFUL !)
#
#
###################################

path.RESULTS = file.path('..','Results')
data.file = 'extra-raw-files-2018-11-21.csv'
data.file = 'all-raw-files-2018-11-21.csv'

d = read.csv(file.path(path.RESULTS,data.file), stringsAsFactors = FALSE)
d = na.omit(d)

file.list.delete = d$name[which(d$delete==TRUE)]
for(f in file.list.delete) {
  print(paste('DELETE: ',f))
}
