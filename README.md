# Coursera: Getting and Cleaning Data
# Course Project

## Description

This project contains scripts to get and clean a set of fitness
activity data.  The original data set, and a full description of the
data was obtained from:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The data used specifically by the cleaning scripts in this repo is being
downloaded from here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Using the Repository Scripts

This repository contains two scripts.  The scripts download the raw
set of data, and then analyze and create two tiny data sets from
the raw measurement data.  To use the scripts, you first must
get the raw data.  You can download and extract the data by hand,
or use the following command to run the R script from a command line
to obtain the data:

```
$ ./get_data.R
```

This command needs to only be run once.  The url location of the raw
data is hardcoded in this script, if the location of the data changes
this variable will have to be updated, or the data obtained by hand.

Once the raw data is available, you can analyze the data and produce
the tiny data sets by running the analysis script:

```
$ ./run_analysis.R
```

If you have Make installed on your system, then simply invoking

```
$ make
```

at the command line in the repository directory will cause the
scripts to be run.  First the data will be downloaded (only
if it is not already downloaded), and then the analysis script
will be run.

The run_analysis.R script can be rerun at any time to (re)produce the
tidy data sets.  The main result of running this script are two
delimiter separated files, placed in the top-level directory, named
ucihar-tidy-subject-activity-measures.txt and
ucihar-tidy-subject-activity-summary.txt.  The summary file is the
final result file asked to be created by the course project
description, and contains a summary of the means of the measurement
variables, broken down by subject and activity factors.
