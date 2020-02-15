# checkRAWfolder

<!-- badges: start -->
<!-- badges: end -->

The goal of checkRAWfolder is to validate the scientific RAW folder and perform some standard file checks. 

From the National Science Foundation, the [Open Data at NSF](https://www.nsf.gov/data/) describes the underlying goals and fosters maintaing metadata. 

## Installation

You can install the released version of checkRAWfolder by:

``` r
# install.packages("devtools")
devtools::install_github("thomasgredig/checkRAWfolder")
```

## Naming Convention

In order to achieve scientifically reproducible data, we shall follow the follow principles: (a) RAW data filenames must be **unique** and the content cannot be altered, (b) the filenames cannot be changed since graphing routines may rely on their unique data filenames, (c) all data files must be in non-proprietary formats, if not, then a second file with the converted text or ASCII format content needs to be saved as well. All data files should have the following format:

>  Date_Project_Initials_Tool_Sample_RunInfo.csv 

(d) all files are in the same folder (no sub-folders). The RAW folder has a flat structrure.

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

# find all the project names
raw.getNamesProjects(p)

# make a data frame with all fields
d = raw.getTable(p)
```

## Loading RAW Data

For graphing and data analysis the correct files need to be loaded. A common approach would be searching data files by `project`, `date`, `user`, or by `instrument`. 

```r
# for instance, find all VSM files from 2018
file.list = raw.findFiles(path.RAW, date='2018', instrument='vsm')
```

As more data is stored, the `file.list` may change overtime. Therefore, the  approach to ensure reproducibility requires the generation of a MD5 string using `raw.getPartialMD5str`, once the exact file list is established, it can be hard-coded as a string (see below for 4 files). Even if more files are generated, the file list is restricted by the MD5 codes. 

```r
md5String = raw.getPartialMD5str(file.list)
file.list = raw.findFiles(path.RAW, date='2018', instrument='vsm',
    md5 = 'a25f3a,66c5d1,4a0333,1b94b5')
```

## Invalid Files

You can also find files with invalid naming convention using the following function, where date is optional

```r
raw.getInvalidFiles(path.RAW, date='2020')
```

## Tools

Some additional tools in the `tools` sub-folder:

Creating a database with all RAW files (configure first lines):
`all-raw-files.R`       

finds additional folders with RAW files:
`find-RAW-elsewhere.R`


## File Checking

Instead of using direct filenames, you can use checksums from the files. For a project that has data added all the time, you could have the following code:

```r
library(checkRAWfolder)
s = raw.getPartialMD5("README.md")

file.list = dir()
# this will return 'README.md'
filename = raw.getFilename(file.list,s)
```

