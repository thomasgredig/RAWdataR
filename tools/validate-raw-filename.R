###################################
#
# (c) 2018 Thomas Gredig
#
# Date: 2018-11-07
#
# Check the validity of the Raw Docs folder
#
#
###################################


path.RAW = file.path('..','..','RAW')

file.list = dir(path.RAW)

q = file.list

q2 = strsplit(q,'-')
q2.len = unlist(lapply(q2,length))
t = which(q2.len<6)
if(length(t)>0) {
  q = q[-t]
  q2 = strsplit(q,'-')
}

d = data.frame(
  m.date = unlist(lapply(q2,'[[',1)),
  m.project = unlist(lapply(q2,'[[',2)),
  m.author = unlist(lapply(q2,'[[',3)),
  m.equipment = unlist(lapply(q2,'[[',4)),
  m.sample = unlist(lapply(q2,'[[',5)),
  m.run =  unlist(lapply(q2,'[[',6))
)
str(d)

levels(d$m.equipment)
