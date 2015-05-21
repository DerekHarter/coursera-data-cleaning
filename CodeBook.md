# Study Design

The original raw data set contained features selected from
accelerometer and gyroscope signal sensors.  You should read the
description and code book files in the raw data directories for more
details on the original measurement instruments and study design.

For the tidy data set we extract from this raw data, we are interested
only in the mean and standard deviation measure estimates of the raw
signal measures collected in the original data.  We extract out only
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

In the original messy data set, several variables were encoded in the
original columns.  We extracted out the following information.  Take
for example the first feature named `tBodyAcc-mean()-X`.  In the messy
data, there were 561 features, many similar to this one, of which only
66 were mean or standard deviation measures.  These features actually
encode several pieces of information.

1. The initial character, `t` or `f` indicates whether the signal was
captured from the raw time domain, or was transformed (using a FFT)
into a frequency domain signal respectively.

2. The next part of this feature represents a measuring device that
recorded signals over time.  For example `BodyAcc` was an
accelerometer placed on the body (I would guess), and `BodyGyro` would
be a gyroscope device, also on the body.  There were also Gravity
based measuring devices.  In the final tidy data set we created, we
choose not to break up this second field, but possibly there should be
further variables, such as whether the device was accelerometer or
gyroscope based, on the body or gravity based, etc.

3. The third part of the feature indicated a method used to estimate
or summarize the signal data.  We only extracted features using
the mean() or std() method for our data.

4. The final part of the feature name indicated an axis along which
the device measured the signal, such as the X, Y or Z axis.  Some
devices don't measure along separate spatial axis, so they can be
considered as NONE or not dimension based measures.

For our tidy data, we gathered all of the 66 mean/std signal measures
from the messy data into a single column.  Then we created 4 columns
named domain, signal, method and axis and separated out the features
into these 4 variables, along with the measured value of the signal
device.

# Variables

1. Name: subject
   - Type: Factor, Ordinal
   - Description: Subject id, an integer variable ranging from 1 to 30
2. Name: activity
   - Type: Factor, Categorical
   - Description: One of 6 activity categories, WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING,
     STANDING, LAYING
3. Name: signal
   - Type: Factor, Categorical
   - Description: One of 13 possible signal/measuring devices used in the study.  The valid devices
     we have in the final tidy data are: BODY_ACC, BODY_ACC_JERK, BODY_ACC_JERK_MAG, BODY_ACC_MAG,
	 BODY_BODY_ACC_JERK_MAG, BODY_BODY_GYRO_JERK_MAG, BODY_BODY_GYRO_MAG, BODY_GYRO, BODY_GYRO_JERK,
	 BODY_GYRO_JERK_MAG, BODY_GYRO_MAG, GRAVITY_ACC, GRAVITY_ACC_MAG.  We put in underscores to
	 separate these factors, as potentially these should be separated into further data variables
	 for the data set.
4. Name: domain
   - Type: Factor, Categorical
   - Description: One of 2 different domain categories: FREQUENCY, TIME.  This variable indicated whether
     the measure was taken from the raw time domain, or converted to the frequency domain using a FFT.
5. Name: method
   - Type: Factor, Categorical
   - Description: One of 2 different measurement methods: MEAN, STD.  All signal measurements were
     estimated using some method, of which we only extracted mean and standard deviation estimates.
6. Name: axis
   - Type: Factor, Categorical
   - Description: One of 4 different axis directions: X, Y, Z or NONE.  Some signal measuring devices
     measured only in one particular axis, while some measurement signals were independent of any
	 axis (and were marked as NONE in this tidy data set).
7. Name: measure
   - Type: numeric, double
   - Description: The numeric value of the measured estimated feature.
     Units of measurement will differ depending mostly on whether this
     was a time domain or frequency domain value.  A mean of a time
     domain value should indicate the mean value of some signal
     measure over some subset of sampled time units (for example, the
     average force or acceleration reading over some time interval
     from an accelerometer).  A mean of a frequency domain value would
     estimate the frequency component measured.  For our summary tidy
     data set, this value is actually the mean of a set of means (or
     the mean of a set of standard deviations).

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
will create two tidy data sets, named
`uci-tidy-subject-activity-measures.txt` and
`uci-tidy-subject-activity-summary.txt`.  The measures tidy data
contains all observed measured variables for all of the original
subjects in both the test and train subdata sets.  The summary tidy
data set contains a summary of the data, grouped by the subject and
activity factors and all variables.  From the top level of your
working repository perform the following
```
./run_analysis.R
```
The analysis and tidying script may be (re)run at any time if the
raw data is present, in order to update and regenerate the tidy
data sets.

If you have Make installed, the makefile will automatically download
the raw data if it is not present, and then run the analysis
script.  You can perform all steps using make from the command line
in the repository directory like this:
```
make
```

# Data Analysis Transformations

## Merge and Gather Messy Raw Data
In this section, we discuss the transformations and decisions made to
produce the final tidy data set.

The run_analysis.R script contains a single function named
extract.dataset This function does the bulk of the work in reading in
and merging the raw messy data, and performs basically the steps 2
through 4 described in the project, to extract only the mean and std
measures, use descriptive activity names, and label the data set
measures with descriptive variable names.  We encapsulated these steps
into a functions since these exact same transformations needed to be
done for both the test and training split data subsets.  So this
function returns a data frame of the gathered data, which we then
later merge together when merging the test and training data.

When performing step 4 in the extract.dataset() function to appropriately
label the data set with descriptive variable names, we did the following.
We made all of the original column feature names upper case initially, because
later we will be splitting up these columns into separate variables, and
turning them into factors, thus by making the names upper case, we end
up with all upper case factor names.  We remove the `(` and `)` parenthesis
and then we extracted only those measures that had `MEAN` or `STD`
in the names, indicating they were using mean or standard deviation to
estimate the signal measures.  After this we end up with a set of 66
features/measures from the original set of 561.  This completed step
2 of the project of extracting only the measurement features measuring
the mean or standard deviation from the messy data.

We then do some further processing on the variable names.  We replaced the
initial `T` or `F` with `TIME_` or `FREQUENCY_` respectively.  We also
replaced all separator characters with an underscore, to make separating
the variables simpler later on.  Finally, some measures ended with an
`_X`, `_Y` or `_Z` indicating the axis of the measurement, but some
measures didn't have an axis component, which later would cause problems.
So for those that don't have an axis component, we appended a `_NONE`
to the variable name, so that when we split into separate columns then
all measures would have 4 variables, the domain, signal, method and
axis variables.

Finally in the extract.dataset() function, we gathered together the
activity and subject information, and bound this all together into
a single data frame.  While reading in the activity information,
we transform the integers in the original messy data into labeled
R factors.

## Tidy DataSet 1

Once the test and training data have been successfully merged, we
perform two tidying activities on the data.  In our first tidying
up, we gather all of the 66 domain_signal_method_axis columns
into a single column for the key, with their measured value for
the value.  This transforms the data frame from a fairly wide one
to a long one.  But we then separate the domain_signal_method_axis
column into 4 separate columns, each containing a separate simple
variable describing some aspect of the measurement device or method.

## Tidy DataSet 2

The final tiny data set we create has the exact same structure
as our first tidy data set, but we simply summarize the
information it contains.  The tidy 1 dataset contains multiple
observations for each signal type for subject/activity.  In
the second tidy data set, we group the first tidy data set by
all of the variables, except the measure variable.  We then
summarize each of the groups by the mean.  Thus we end up with
a mean of a group of means, or a mean of a group of standard
deviations in the tidy 2 dataset.  The second tidy data set
contains a total of 11880 observations.  This is because
we have 30 subjects, with 6 activities each, and we had 66
measures that we are summarizing (30 * 6 * 66 = 11880).
