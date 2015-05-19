# extract all measured features, then filter out to only get 
# measure features that are mean() or std() measurements
features <- read.table('features.txt')
m <- read.table('test/X_test.txt', col.names=features[,2])
measure.indexes = grep("mean\\(\\)|std\\(\\)", features[,2])
measures <- m[measure.indexes]

# Get the activity information, transform into descriptive labels
a <- read.table('test/y_test.txt')
activity = factor(a[,1], labels=c('WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING'))

# get the subject information
subjects <- read.table('test/subject_test.txt')

# build dataframe from test data
test.df <- subjects
names(test.df) <- c('subject')
test.df$activity <- activity
test.df <- cbind(test.df, measures)
