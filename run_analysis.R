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

extract.dataset <- function(rawDataDir, subdata) {
    # This function extracts and tidies the measures, activity and
    # subject id data from the test or train subdirectories of the raw
    # UCI HAR dataset.  This function is given the path to the rawDataDir
    # and the subdirectory ('test' or 'train', for now).  This function
    # extracts the mean() and std() measures, and combines in the subject
    # and activity information. 
    #
    # Args:
    #   rawDataDir: A string, the absolute or relative path to location where
    #       the raw UCI HAR data has been extracted.
    #    subdata: A string, the subdirectory/data to process, either 'test' or
    #       'train' for now.  Should contian the X_test.txt file with
    #       measurement data and teh y_test.txt file with the labeled activity
    #       data.
    #
    # Returns:
    #    A dataframe of the subject, activity and measurements data tidied
    #    up from the test/train subdirectory and feature information
    
    # (2) extract only the measurement features measuring mean and standard 
    # deviation
    featureFileName <- 'features.txt'
    featureFilePath <- file.path(rawDataDir, featureFileName)
    features <- read.table(featureFilePath)
    measure.indexes = grep("mean\\(\\)|std\\(\\)", features[,2])

    # now actually extract only those measurements we are interested in and
    # (4) appropriately label the data set with descriptive variable names
    measuresFileName <- sprintf('X_%s.txt', subdata)
    measuresFilePath <- file.path(rawDataDir, subdata, measuresFileName)
    measures <- read.table(measuresFilePath, col.names=gsub('\\(\\)', '', features[,2]))
    measures <- measures[measure.indexes]

    # (3) use descriptive activity names to name the activities in
    # the dataset
    activityFileName <- sprintf('y_%s.txt', subdata)
    activityFilePath <- file.path(rawDataDir, subdata, activityFileName)
    a <- read.table(activityFilePath)
    activity = factor(a[,1], labels=c('WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING'))

    # get the subject information needed for step 5
    subjectFileName <- sprintf('subject_%s.txt', subdata)
    subjectFilePath <- file.path(rawDataDir, subdata, subjectFileName)
    subjects <- read.table(subjectFilePath)
    
    # build dataframe from data and return it
    result.df <- subjects
    names(result.df) <- c('subject')
    result.df$activity <- activity
    result.df <- cbind(result.df, measures)
    result.df
}
    
# we assume all the raw data is in a subdirectory with this name, structured
# further into test and train subdirectories
rawDataDir <- 'UCI HAR Dataset'

# perform steps 2, 3 and 4 on the test and train sub data
test.df <- extract.dataset(rawDataDir, 'test')
train.df <- extract.dataset(rawDataDir, 'train')

# perform step 1, merte the training and test sets to create one data set
merged.df <- rbind(test.df, train.df)

# not asked for in project, but we write this first tidy data set of the
# merged test/train data with subject, activity and mean/std measures to
# a txt file
write.table(merged.df, 'ucihar-tidy-subject-activity-measures.txt', row.names=FALSE)

# write tidy data to file
#write.table(test.df, 'test-dataframe.txt', row.names=FALSE)
