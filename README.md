# RAWdataR

<!-- badges: start -->
[![Codecov test coverage](https://codecov.io/gh/thomasgredig/RAWdataR/branch/master/graph/badge.svg)](https://app.codecov.io/gh/thomasgredig/RAWdataR?branch=master)
<!-- badges: end -->

The goal of RAWdataR is to validate the scientific RAW folder and perform some standard file checks in R language.

From the National Science Foundation, the [Open Data at NSF](https://www.nsf.gov/data/) describes the underlying goals and fosters maintaing metadata. 

## Installation

You can install the released version of RAWdataR by:

``` r
# install.packages("devtools")
devtools::install_github("thomasgredig/RAWdataR")
```

## Documentation

The **[reference documentation](https://thomasgredig.github.io/RAWdataR/)** has examples and a list of all functions published in this package.




## Naming Convention

In order to achieve scientifically reproducible data, we shall follow the follow principles: 

- RAW data filenames must be **unique** and the content cannot be altered, 
- the filenames cannot be changed since graphing routines may rely on their unique data filenames, 
- all data files must be in non-proprietary formats, if not, then a second file with the converted text or ASCII format content needs to be saved as well. All data files should have the following format:

>  Date_Project_Initials_Tool_Sample_RunInfo.csv 

- all files are in the same folder (no sub-folders). The RAW folder has a flat structrure.

The **date** is in `yyyymmdd` format and represents the date of the data collection start. The **project string** is assigned by the project manager and the initials are from the person collecting data.

**Tools** are short strings and represent the machine taking the data, see [Tool List](https://github.com/thomasgredig/MSthesis-Guidelines).

Each **sample** should have a unique name, generally starting witht he initials of the person, and following the date of sample creation. 
If more than 1 data collection is made in one day, then **RunInfo** is added to discriminate or to add more description to the RAW data file. 


## Example

This is a basic example which shows you how to check your RAW folder

``` r
library(RAWdataR)

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


## File Checking

Instead of using direct filenames, you can use checksums from the files. For a project that has data added all the time, you could have the following code:

```r
library(RAWdataR)
s = raw.getPartialMD5("README.md")

file.list = dir()
# this will return 'README.md'
filename = raw.getFilename(file.list,s)
```


## Data Project

If you have a new project with RAW data, you can quickly initialize it using the `raw.dataProject()` function. It will prompt you to select a directory that has a `RAW` subfolder and then generate the R data package. Once generated, you can open the new data package and run the `_init.R` code, which helps you prepare a documented data package. Afterwards, it is recommended to add tests to verify data content.

```{r}
RAWdataR::raw.dataProject()
```

You can use `raw.dataMaker()` to generate a make.data..R file that creates a dataset.

