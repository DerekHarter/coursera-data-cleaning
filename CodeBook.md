# Study Design

The original raw data set contained features selected for this
database come from the accelerometer and gyroscope 3-axial raw signals
tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to
denote time) were captured at a constant rate of 50 Hz. Then they were
filtered using a median filter and a 3rd order low pass Butterworth
filter with a corner frequency of 20 Hz to remove noise. Similarly,
the acceleration signal was then separated into body and gravity
acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another
low pass Butterworth filter with a corner frequency of 0.3 Hz.

Subsequently, the body linear acceleration and angular velocity were
derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and
tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional
signals were calculated using the Euclidean norm (tBodyAccMag,
tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

Finally a Fast Fourier Transform (FFT) was applied to some of these
signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ,
fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to
indicate frequency domain signals).

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

From this set of variables, various estimates were made, including the
mean() and std() of various measurements.

For the tidy data set we extract from this raw data, we are interested
only in the mean and standard deviation measure estimates of the
various features.  We extract out only these measures from the
measured features.  We then further summarize the data by grouping by
subjects and activity type.  The original raw data contained
measurements from 30 subjects (split into test and training data
sets).  The 30 subjects had their activities recorded on video, and
labeled into 6 categories:

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
   - Description: The 6 activity categories, WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING,
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
