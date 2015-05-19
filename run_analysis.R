#!/usr/bin/Rscript
## Author: Derek Harter
## Date  : May 17, 2015
## Assig : Data Science, Getting and Cleaning Data: Course Project
##
## Desc  : This script implements the steps to create a tidy data set
##  from the raw data files given for the course project.  This script
##  extracts the mean and std measurements, and adds in the subject
##  and activity information.  It does this for both the test and
##  training data in the raw data set, then merges and writes out
##  the resulting merged data set.  Finally, it creates an
##  independent tidy data set summary of the average of each
##  measured variable by activity and subject

# we assume all the raw data is in a subdirectory with this name, structured
# further into test and train subdirectories
rawDataDir <- 'UCI HAR Dataset'

# Part 1: Tdy up the test data

# 2. extract only measurements on the mean and standard deviation
featureFileName <- 'features.txt'
featureFilePath <- file.path(rawDataDir, featureFileName)
features <- read.table(featureFilePath)
measure.indexes = grep("mean\\(\\)|std\\(\\)", features[,2])

# extract all measured features, then filter out to only get 
# measure features that are mean() or std() measurements
# 4. appropriately label the data set with descriptive variable names
measuresFileName <- 'test/X_test.txt'
measuresFilePath <- file.path(rawDataDir, measuresFileName)
measures <- read.table(measuresFilePath, col.names=gsub('\\(\\)', '', features[,2]))
measures <- measures[measure.indexes]

# 3. use descriptive activity names to name the activities in
# the dataset
activityFileName <- 'test/y_test.txt'
activityFilePath <- file.path(rawDataDir, activityFileName)
a <- read.table(activityFilePath)
activity = factor(a[,1], labels=c('WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING'))

# get the subject information needed for step 5
subjectFileName <- 'test/subject_test.txt'
subjectFilePath <- file.path(rawDataDir, subjectFileName)
subjects <- read.table(subjectFilePath)

# build dataframe from test data
test.df <- subjects
names(test.df) <- c('subject')
test.df$activity <- activity
test.df <- cbind(test.df, measures)

# write tidy data to file
write.table(test.df, 'test-dataframe.txt', row.names=FALSE)
