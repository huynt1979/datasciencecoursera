# To execute this file, issue the following command:
# Rscript run_analysis.R
#
library(plyr)

checkFile <- function(fname) {
  if (!file.exists(fname))
    quit(save = "no", 0)
}

cat("Please enter path to data directory: ")
conn <- file("stdin")
dataDir <- readLines(conn, 1)
close(conn)
cat("You have entered the following path: ")
cat(paste(dataDir, '\n'))

if (!dir.exists(dataDir)) {
  cat(dataDir, ' doesn\'t exist. Terminated!!!\n')
  quit(save = "no", 1)
}
#setwd(dataDir)
checkFile(file.path(dataDir, 'features.txt'))
checkFile(file.path(dataDir, 'activity_labels.txt'))
checkFile(file.path(dataDir, 'train/subject_train.txt'))
checkFile(file.path(dataDir, 'train/X_train.txt'))
checkFile(file.path(dataDir, 'train/y_train.txt'))
checkFile(file.path(dataDir, 'test/X_test.txt'))
checkFile(file.path(dataDir, 'test/y_test.txt'))

cat('Running...\n')
# Read features
features <- read.table(file.path(dataDir, 'features.txt'), header = FALSE)
names(features) <- c("FCode", "Feature")
selectFeatureCols <- grep('mean\\(\\)|std\\(\\)', features$Feature)
selectFeatureNames <- as.character(features[selectFeatureCols, "Feature"])

# Read activities
activities <- read.table(file.path(dataDir, 'activity_labels.txt'), header = FALSE)
names(activities) <- c('ACode', 'Activity')

# Read training data
trainSubject <- read.table(file.path(dataDir, 'train/subject_train.txt'), header = FALSE)
names(trainSubject) <- c('Subject')
trainData <- read.table(file.path(dataDir, 'train/X_train.txt'), header = FALSE)
trainLabel <- read.table(file.path(dataDir, 'train/y_train.txt'), header = FALSE)
names(trainLabel) <- c('ACode')

# Read testing data
testSubject <- read.table(file.path(dataDir, 'test/subject_test.txt'), header = FALSE)
names(testSubject) <- c('Subject')
testData <- read.table(file.path(dataDir, 'test/X_test.txt'), header = FALSE)
testLabel <- read.table(file.path(dataDir, 'test/y_test.txt'), header = FALSE)
names(testLabel) <- c('ACode')

# 1. Merge training with testing data
mergeData <- rbind(trainData, testData)

# 2. Extract only mean and std features
mergeData <- mergeData[ ,selectFeatureCols]

# 3. Name activities
mergeLabel <- rbind(trainLabel, testLabel)
activityData <- cbind(mergeLabel, mergeData)

# 4. Use labels for variable names
activityData <- join(activities, activityData, by = "ACode", type= "inner")
featureNames <- c('ACode', 'Activity', selectFeatureNames)
names(activityData) <- featureNames
activityData <- activityData[ , featureNames]

# 5. Average per activity per subject
mergeSubject <- rbind(trainSubject, testSubject)
subjectedData <- cbind(mergeSubject, activityData)
subjectedData$ACode <- NULL
avgSubjectedData <- ddply(subjectedData, .(Activity, Subject), colwise(mean), na.rm = TRUE)

# Output as text file
write.table(arrange(avgSubjectedData, Activity, Subject), file="output.txt", row.names = FALSE)
cat("Output has been written to file output.txt\n")