# checkRAWfolder

<!-- badges: start -->
<!-- badges: end -->

The goal of checkRAWfolder is to validate the scientific RAW folder.

## Installation

You can install the released version of checkRAWfolder by:

``` r
# install.packages("devtools")
devtools::install_github("thomasgredig/checkRAWfolder")
```

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
