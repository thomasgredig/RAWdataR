# RAWdataR 1.2.3

* move header to the front in RAW-ID.csv file
* update `raw.dataMaker()` to generate makeData()

# RAWdataR 1.2.2

* add `raw.dataXRD()` for XRD

# RAWdataR 1.2.1

* add `raw.dataFilesAFM()` for AFM file support
* `raw.getDatabase()` will now append the folder to the package
* fix bugs

# RAWdataR 1.2.0

* add post function to `raw.updateID()`, such that type or sample names could be adjusted according to specific rules. 

# RAWdataR 1.1.0

* create new column in dataRAW with META data
* add file generation date
* store data in header
* fix NA with empty strings after writing and reading CSV

# RAWdataR 1.0.1

* updated documentation

# RAWdataR 0.6.4

* add SQL installation function `raw.installSQLremote()`
* allow generation of a TeX article that shows all figures

# RAWdataR 0.6.3

* update AFM data maker (SQL integration)

# RAWdataR 0.6.2

* add `XRR` file type

# RAWdataR 0.6.1

* `RAW` folder can be in a folder above the selected folder with `raw.dataProject()`
* function `fig2tex()` to save graphs as a TeX snippet for import

# RAWdataR 0.6

* adding `raw.dataProject()` to generate a data R project start framework quickly
* use `raw.dataMaker()` to generate dataset maker files for RAWID etc.

# RAWdataR 0.5.2

* `raw.updateID()` uses `data-raw` as the default raw folder and also for results

# RAWdataR 0.5.2

* allow to search for partial filename matching in `raw.getIDfromFile()`
* add `raw.updateID()` to build unique IDs for files based on MD5
* add function `path.goUpOneDir()` to easily go up one directory

# RAWdataR 0.5.1

* allow recursive search (subfolders) in raw data folder
* Number of valid files returned by `raw.inspectFolder()`
* Instruments "xrd" and "XRD" are converted to lowercase
* `raw.fixInvalidFile()` can add instrument, user, project, and sample
* Fix findFiles, so that only specific item is searched.


# RAWdataR 0.5

* Add `raw.fixInvalidFile()` to fix filenames
* Write path inspector
* Fix `raw.findFiles()` by MD5 code
* Validation of files `raw.isValid()`
* (Documentation with References)[https://thomasgredig.github.io/RAWdataR/]
* tools library used for MD5 checks
* use_news_md()
* Added a `NEWS.md` file to track changes to the package.
