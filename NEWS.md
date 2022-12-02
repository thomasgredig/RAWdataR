# RAWdataR 0.6.1

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
