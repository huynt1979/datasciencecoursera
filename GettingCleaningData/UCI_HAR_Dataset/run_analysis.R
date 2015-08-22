library(plyr)

#dataDir <- ''
#setwd(dataDir)

# Read features
features <- read.table('features.txt', header = FALSE)
names(features) <- c("FCode", "Feature")
selectFeatureCols <- grep('mean\\(\\)|std\\(\\)', features$Feature)
selectFeatureNames <- as.character(features[selectFeatureCols, "Feature"])

# Read activities
activities <- read.table('activity_labels.txt', header = FALSE)
names(activities) <- c('ACode', 'Activity')

# Read training data
trainSubject <- read.table('train/subject_train.txt', header = FALSE)
names(trainSubject) <- c('Subject')
trainData <- read.table('train/X_train.txt', header = FALSE)
trainLabel <- read.table('train/y_train.txt', header = FALSE)
names(trainLabel) <- c('ACode')

# Read testing data
testSubject <- read.table('test/subject_test.txt', header = FALSE)
names(testSubject) <- c('Subject')
testData <- read.table('test/X_test.txt', header = FALSE)
testLabel <- read.table('test/y_test.txt', header = FALSE)
names(testLabel) <- c('ACode')

# 1. Merge training with testing data
mergeData <- rbind(trainData, testData)

# 2. Extract only mean and std features
mergeData <- mergeData[ ,featureCols]

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
