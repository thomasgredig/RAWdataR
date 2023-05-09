# generate site
# use_vignette("")

devtools::document()
pkgdown::build_site()

library(covr)
covr::report()

file.remove('./RAW/test/test.txt')
file.remove('./RAW/test2.txt')
raw.updateID(pRAW = './RAW', pRESULTS = './RESULTS', forceRegenerate=TRUE, verbose=TRUE) -> q
q1 = nrow(q)
raw.updateID(pRAW = './RAW', pRESULTS = './RESULTS') -> q
q2 = nrow(q)
q1 == q2

file.create('./RAW/test.txt')
raw.updateID(pRAW = './RAW', pRESULTS = './RESULTS', verbose=TRUE) -> q
q2 = nrow(q)
q$crc
tail(q,n=2)

file.create('./RAW/test2.txt')
raw.updateID(pRAW = './RAW', pRESULTS = './RESULTS', verbose=TRUE) -> q
q2 = nrow(q)
tail(q,n=2)


write.csv(q2,'./RAW/test2.txt')
raw.updateID(pRAW = './RAW', pRESULTS = './RESULTS', verbose=TRUE) -> q
q2 = nrow(q)
tail(q,n=7)

file.remove('./RAW/test2.txt')
raw.updateID(pRAW = './RAW', pRESULTS = './RESULTS', verbose=TRUE) -> q
q2 = nrow(q)
tail(q,n=7)


raw.updateID(pRAW = './RAW', pRESULTS = './RESULTS', verbose=TRUE) -> q
q2 = nrow(q)
tail(q,n=7)


raw.getIDbyFile('/Users/gredigcsulb/Documents/GitHub/RAWdataR/RAW/test.txt',pRESULTS = './RESULTS')
raw.getFileByID(45, pRAW='./RAW', pRESULTS='./RESULTS')

raw.getFileByID(c(10:15, 18),  pRESULTS = './RESULTS')$filename -> file.list
raw.getIDbyFile(c("bogus.txt",file.list), pRESULTS = './RESULTS')$ID

# test fig2tex

d = data.frame(x=1:30, y=(1:30)^2)
g1 <- ggplot(d, aes(x,y)) + geom_point(size=3, col='red') + theme_bw()
plot(g1)
figFile = tempfile()
fig2tex(g1, fileGraph="test.png", caption="today")
raw.texArticle('.')


#


fname = file.path(tempdir(), "afm.sqlite")
mydb <- DBI::dbConnect(RSQLite::SQLite(), fname)
afmFile = AFM.getSampleImages(type='tiff')[1]
a = AFM.import(afmFile)
AFM.writeDB(a, mydb, 7, verbose=FALSE)
b = AFM.readDB(mydb, 7)
DBI::dbDisconnect(mydb)
plot(b)
fname
