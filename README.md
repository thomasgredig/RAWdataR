# checkRAWfolder

<!-- badges: start -->
<!-- badges: end -->

The goal of checkRAWfolder is to validate the scientific RAW folder.

From the National Science Foundation, the [Open Data at NSF](https://www.nsf.gov/data/) describes the underlying goals and fosters maintaing metadata. 

## Installation

You can install the released version of checkRAWfolder by:

``` r
# install.packages("devtools")
devtools::install_github("thomasgredig/checkRAWfolder")
```

## Naming Convention

RAW data filenames must be **unique** and the content cannot be altered. The filenames cannot be changed since graphing routines may rely on their unique data filenames. All data fiels must be in non-proprietary formats, if not, then a second file with the converted text or ASCII format content needs to be saved as well. All data files should have the following format:

  Date_Project_Initials_Tool_Sample_RunInfo.csv 

All files are in the same folder (no sub-folders). The RAW folder has a flat structrure.

The **date** is in `yyyymmdd` format and represents the date of the data collection start. The **project string** is assigned by the project manager and the initials are from the person collecting data.

**Tools** are short strings and represent the machine taking the data, see [Tool List](https://github.com/thomasgredig/MSthesis-Guidelines).

Each **sample** should have a unique name, generally starting witht he initials of the person, and following the date of sample creation. 

If more than 1 data collection is made in one day, then **RunInfo** is added to discriminate or to add more description to the RAW data file. 

## Example

This is a basic example which shows you how to check your RAW folder

``` r
library(checkRAWfolder)

# folder path
p = 'Research-User/RAW'

# does it have the proper structure?
raw.checkNoSubfolders(p)

# get the getUsername
raw.getUsername(p)

# make a data frame with all fields
d = raw.getTable(p)
```

## Tools

Some additional tools in the `tools` sub-folder:

Creating a database with all RAW files:
`all-raw-files.R`       

finds additional folders with RAW files:
`find-RAW-elsewhere.R`
