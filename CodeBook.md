# Study Design

The original raw data set contained features selected for this
database come from accelerometer and gyroscope sensors.  You should
read the description and code book files in the raw data directories
for more details on the original measurement instruments and study
design.

For the tidy data set we extract from this raw data, we are interested
only in the mean and standard deviation measure estimates of the raw
various features collected in the original data.  We extract out only
these measures from the measured features.  We then further summarize
the data by grouping by subjects and activity type.  The original raw
data contained measurements from 30 subjects (split into test and
training data sets).  The 30 subjects had their activities recorded on
video, and labeled into 6 categories:

1. WALKING
2. WALKING_UPSTAIRS
3. WALKING_DOWNSTAIRS
4. SITTING
5. STANDING
6. LAYING

We find all data in the original set of 10299 observations, and group
then by subject (30 subjects) and activity (6 categories), giving 180
different groups.  We calculate the mean of each of the raw
measurement signals for each of these 180 groupings, and the result is
the tidy data set given here for analysis.

# Variables

1. Name: subject
   - Type: Factor, Ordinal
   - Description: Subject id, an integer variable ranging from 1 to 30
2. Name: activity
   - Type: Factor, Categorical
   - Description: One of 6 activity categories, WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING,
     STANDING, LAYING
3. (columns 3-68) Names: "tBodyAcc.mean.X", "tBodyAcc.mean.Y",
   "tBodyAcc.mean.Z", "tBodyAcc.std.X", "tBodyAcc.std.Y",
   "tBodyAcc.std.Z", "tGravityAcc.mean.X", "tGravityAcc.mean.Y",
   "tGravityAcc.mean.Z", "tGravityAcc.std.X", "tGravityAcc.std.Y",
   "tGravityAcc.std.Z", "tBodyAccJerk.mean.X", "tBodyAccJerk.mean.Y",
   "tBodyAccJerk.mean.Z", "tBodyAccJerk.std.X", "tBodyAccJerk.std.Y",
   "tBodyAccJerk.std.Z", "tBodyGyro.mean.X", "tBodyGyro.mean.Y",
   "tBodyGyro.mean.Z", "tBodyGyro.std.X", "tBodyGyro.std.Y",
   "tBodyGyro.std.Z", "tBodyGyroJerk.mean.X", "tBodyGyroJerk.mean.Y",
   "tBodyGyroJerk.mean.Z", "tBodyGyroJerk.std.X",
   "tBodyGyroJerk.std.Y", "tBodyGyroJerk.std.Z", "tBodyAccMag.mean",
   "tBodyAccMag.std", "tGravityAccMag.mean", "tGravityAccMag.std",
   "tBodyAccJerkMag.mean", "tBodyAccJerkMag.std", "tBodyGyroMag.mean",
   "tBodyGyroMag.std", "tBodyGyroJerkMag.mean",
   "tBodyGyroJerkMag.std", "fBodyAcc.mean.X", "fBodyAcc.mean.Y",
   "fBodyAcc.mean.Z", "fBodyAcc.std.X", "fBodyAcc.std.Y",
   "fBodyAcc.std.Z", "fBodyAccJerk.mean.X", "fBodyAccJerk.mean.Y",
   "fBodyAccJerk.mean.Z", "fBodyAccJerk.std.X", "fBodyAccJerk.std.Y",
   "fBodyAccJerk.std.Z", "fBodyGyro.mean.X", "fBodyGyro.mean.Y",
   "fBodyGyro.mean.Z", "fBodyGyro.std.X", "fBodyGyro.std.Y",
   "fBodyGyro.std.Z", "fBodyAccMag.mean", "fBodyAccMag.std",
   "fBodyBodyAccJerkMag.mean", "fBodyBodyAccJerkMag.std",
   "fBodyBodyGyroMag.mean", "fBodyBodyGyroMag.std",
   "fBodyBodyGyroJerkMag.mean", "fBodyBodyGyroJerkMag.std"
   - Type: Continuous
   - Description: These values will be the mean value of each measure for
     all original observations in the raw data that were for a given
     subject/activity group combination.  Thus these represent the mean
     of a group of means or of a group of standard deviations from the
     original set of observations.

# Instructions (To Reproduce Analysis)

1. Step 1 - Obtain the raw data.  From the command line
run the get_data.R script.  This will download the raw
data zip file, and extract its contents to a folder named
`UCI HAR Dataset`.  At the top level of your working repository
perform the following
```
./get_data.R
```
The url location of the .zip file that is downloaded is provided
in the get_data.R script.  If this location changes, you need to
update the url appropriately, or download and extract the zip file
by hand.

2. Step 2 - run data analysis and tidy the data.  The analysis script
will create two tidy data sets, named `uci-tidy-subject-activity-measures.txt`
and `uci-tidy-subject-activity-means.txt`.  The measures tidy data
contains all observed measured variables for all of the original
subjects in both the test and train subdata sets.  The means tidy
data set contains a summary of the data, grouped by the subject
and activity factors.  From the top level of your working repository
perform the following
```
./run_analysis.R
```
The analysis and tidying script may be (re)run at any time if the
raw data is present, in order to update and regenerate the tidy
data sets.

# Data Analysis Transformations

In this section, we discuss the transformations and decisions made to
produce the final tidy data set.

The run_analysis.R script contains a single function named
extract.dataset This function does the bulk of the work in tidying the
data, and performs basically the steps 2 through 4 described in the
project, to extract only the mean and std measures, use descriptive
activity names, and label the data set measures with descriptive variable
names.  We encapsulated these steps into a functions since these exact
same transformations needed to be done for both the test and training
split data subsets.  So this function returns a data frame of the
gathered data, which we then later merge together when merging the
test and training data.

Some notes about the transformations in this function.  We use
a regular expression to search for the feature/measure names
that have either the pattern `mean()` or `std()` in them.  There
were 66 measurements in the raw data that appear to be means or
standard deviations collected from sensor data.  We use the
grep function to create a set of column indexes, called measure.indexes.
These are the indexes of only those columns that are means or std
measurements, that we want to extract.  In addition, we clean
up the names of the variables in this part of the code, bu removing
the '()' from the names.  When you assign strings to column names when
doing a read.table, it appears that special characters like '-', '('
and ')' are transformed to '.' in the data frame.  By removing the '()'
before assigning the names to the columns, we made the column/feature
variable names more readable.

Besides getting the measurements of interest, this function also
extracts out the subject id and activity label information.  These are
in separate files, that are simply read in.  While reading in
the activity information, we transform the activity integer labels
into more readable category labels.  Finally, this function simply
combines the 3 sets of data into a single data frame, and returns it.

We use the function to get the needed data from the test and training
subdata sets.  Outside of the function, we get this data and merge
it together into one big data frame.

With this merged set of 10299 observations, we then group the data by
subject id and activity category using the 'aggregate()' method.  This
gives us a new data frame of only 180 observations (30 subjects with 6
activity categories for each subject).  For each group, we calculate
the mean of each of the original measures within that group.  Thus for
each of the 180 observations in the final tidy data set, each measure
is a mean of the sensor measurements for all measures in the given
subject/activity group of observations.
