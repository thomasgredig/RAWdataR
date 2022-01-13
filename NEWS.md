# RAWdataR 0.5.1

* allow recursive search (subfolders) in raw data folder
* Number of valid files returned by `raw.inspectFolder`
* Instruments "xrd" and "XRD" are converted to lowercase
* `raw.fixInvalidFile` can add instrument, user, project, and sample
* Fix findFiles, so that only specific item is searched.


# RAWdataR 0.5

* Add `raw.fixInvalidFile` to fix filenames
* Write path inspector
* Fix `raw.findFiles` by MD5 code
* Validation of files `raw.isValid()`
* (Documentation with References)[https://thomasgredig.github.io/RAWdataR/]
* tools library used for MD5 checks
* use_news_md()
* Added a `NEWS.md` file to track changes to the package.
