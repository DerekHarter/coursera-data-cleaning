#!/usr/bin/Rscript
## Author: Derek Harter
## Date  : May 17, 2015
## Assig : Data Science, Getting and Cleaning Data: Course Project
##
## Desc  : This script implements the steps to create a tidy data set
##  from the raw data files given for the course project.  This script
##  extracts the mean and std measurements, and adds in the subject
##  and activity information.  It does this for both the test and
##  training data in the raw data set, then merges the data sets.
##  It then creates tidy data sets from this raw merged data,
##  gathering and splitting out the true variables in the data.  
##  A second independent tidy data set is then created that summarizes
##  all of the measures in the original tidy data set.
library(dplyr)
library(tidyr)

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

    # (4) approrpiately label the data set with descriptive variable names
    # here we first clean up the feature names, making it easier to find the
    # measurements we are interested in.  We leave the - in the measure
    # variable names for now
    featureFileName <- 'features.txt'
    featureFilePath <- file.path(rawDataDir, featureFileName)
    features <- read.table(featureFilePath)
    featureNames <- toupper(features[,2]) # all variables use only upper case
    featureNames <- sub('\\(', '', featureNames) # remove (
    featureNames <- sub('\\)', '', featureNames) # remove )

    # (2) extract only the measurement features measuring mean and standard
    # deviation
    featureIndexes <- grep("-(MEAN|STD)(-|$)", featureNames)
    measuresFileName <- sprintf('X_%s.txt', subdata)
    measuresFilePath <- file.path(rawDataDir, subdata, measuresFileName)
    measures <- read.table(measuresFilePath, col.names=featureNames)
    measures <- measures[featureIndexes]

    # further process the variable names.  We split apart variable
    # names into components that we will later use to gather and
    # separate the columns into the true tidy variables
    # separate out the initial T or F, indicating time or frequencey domain
    names(measures) <- sub('^T', 'TIME_', names(measures))
    names(measures) <- sub('^F', 'FREQUENCY_', names(measures))
    
    # replace the periods with underscores, separating the other elements
    names(measures) <- gsub('\\.', '_', names(measures))
    
    # Some signals are only on X,Y or Z axis, but some signals do not
    # have an axis, indicate no axis for those items
    names(measures) <- gsub('_MEAN$', '_MEAN_NONE', names(measures))
    names(measures) <- gsub('_STD$', '_STD_NONE', names(measures))
    
    
    # (3) use descriptive activity names to name the activities in
    # the dataset
    activityFileName <- sprintf('y_%s.txt', subdata)
    activityFilePath <- file.path(rawDataDir, subdata, activityFileName)
    a <- read.table(activityFilePath)
    activity = factor(a[,1], labels=c('WALKING', 'WALKING_UPSTAIRS', 
                                      'WALKING_DOWNSTAIRS', 'SITTING', 
                                      'STANDING', 'LAYING'))

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


## Part 1: Gather and merge the Data
# we assume all the raw data is in a subdirectory with this name, structured
# further into test and train subdirectories
rawDataDir <- 'UCI HAR Dataset'

# perform steps 2, 3 and 4 on the test and train sub data
test.df <- extract.dataset(rawDataDir, 'test')
train.df <- extract.dataset(rawDataDir, 'train')

# perform step 1, merge the training and test sets to create one data set
merged.df <- rbind(test.df, train.df)



## Part 2: tidy the data
# tidy this first version of the merged data frame.  First of all, the true
# variables in this data appear to be the signal device (like Body Accelerometer
# or Body Gyroscope, etc), whether data was in the TIME vs. FREQUENCY domain,
# the estimate method used for the data, of which we only kept the MEAN
# and STD standard deviations, and then the axis for the measured signal, like X,
# Y, Z, or in some cases the devices don't have measurements along the 3 separate
# axis.  First of all, we gather all the columns that are not true variables
# into 1 column.
tidy.df <- gather(merged.df, domain_signal_method_axis, measure, 
                  -subject, -activity)

# We prepared the variables to be separated by formatting the column names
# previously.  These names are now in the domain_signal_variable_axis column.
# We now separate this information into the 4 appropriate columns.
tidy.df <- separate(tidy.df, domain_signal_method_axis, 
                    c('domain', 'signal', 'method', 'axis'))

# The proper ordering should be that the signal device is most important
# followed by the time/frequency domain, then the measurement method and then axis
# so we rearrange the columns
tidy.df <- select(tidy.df, subject, activity, signal, domain, method, axis, measure)

# And finally, all of these new columns end up being strings, so we turn them
# into true R factors.
tidy.df$domain <- factor(tidy.df$domain)
# perhaps this could/should be variables as well, like location (Body or Gravity), and
# type (gyroscope or accelerometer), etc.  I relabel here using underscores, in
# case we wanted to separate this column into variables as well at some point.
tidy.df$signal <- factor(tidy.df$signal, 
                         labels=c('BODY_ACC', 'BODY_ACC_JERK', 'BODY_ACC_JERK_MAG', 
                                  'BODY_ACC_MAG', 'BODY_BODY_ACC_JERK_MAG', 
                                  'BODY_BODY_GYRO_JERK_MAG', 'BODY_BODY_GYRO_MAG', 
                                  'BODY_GYRO', 'BODY_GYRO_JERK', 'BODY_GYRO_JERK_MAG',
                                  'BODY_GYRO_MAG', 'GRAVITY_ACC', 'GRAVITY_ACC_MAG'))
tidy.df$method <- factor(tidy.df$method)
tidy.df$axis <- factor(tidy.df$axis)

# not asked for in project, but we write this first tidy data set of the
# merged test/train data with subject, activity and their measures to
# a txt file
write.table(tidy.df, 'ucihar-tidy-subject-activity-measures.txt', row.names=FALSE)

# perform step 5, create a second, independent tidy data set with the
# averages of each variable for each activity and each subject.
# I assume we should end up with 6 lines for each subject, which have the
# average of all observations for each of our 66 variables for the
# subject/activity group (thus the final file has 30 * 6 * 66 = 11880 observations)
tidy2.df <- tidy.df %>% group_by(subject, activity, signal, domain, method, axis) %>% summarise_each(funs(mean))
write.table(tidy2.df, 'ucihar-tidy-subject-activity-summary.txt', row.names=FALSE)