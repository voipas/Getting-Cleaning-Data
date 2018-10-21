library(dplyr)
library(plyr)
library(knitr)

#####################################################################################################
# Getting the data
#####################################################################################################


# Download data archive
archiveUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
archiveFile <- "UCI HAR Dataset.zip"

# Check if the archive already exists, otherwise download
if(!file.exists(archiveFile)) {  download.file(archiveUrl, archiveFile, method = "curl") }


# Check if the folder already exists, otherwise Unpack the archive
dataFolder <- "UCI HAR Dataset"
if(!file.exists(dataFolder)) { unzip(archiveFile) }



#####################################################################################################
# Reading the data
#####################################################################################################

# Activities
# Activities Labels has two columns : ID and Label
activityLabels <- read.table(file.path(dataFolder,"activity_labels.txt"), header = FALSE)

# Training data
# Subject train - each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
trainSub <- read.table(file.path(dataFolder,"train","subject_train.txt"), header = FALSE)
# Training set
trainX <- read.table(file.path(dataFolder,"train","X_train.txt"), header = FALSE)
# Training labels
trainY <- read.table(file.path(dataFolder,"train","y_train.txt"), header = FALSE)


# Test data
testSub <- read.table(file.path(dataFolder,"test","subject_test.txt"), header = FALSE)
# Test set
testX <- read.table(file.path(dataFolder,"test","X_test.txt"), header = FALSE)
# Test labels
testY <- read.table(file.path(dataFolder,"test","y_test.txt"), header = FALSE)


# Features - list of all features
features <- activityLabels <- read.table(file.path(dataFolder,"features.txt"), header = FALSE)


#####################################################################################################
# 1. Merges the training and the test sets to create one data set.
#####################################################################################################

# Merging data
dataSub <- rbind(trainSub, testSub)
dataX <- rbind(trainX, testX)
dataY <- rbind(trainY, testY)

# Set column names for each table
names(dataSub) <- c("subject")
names(dataX) <- features$V2                # V2 column consists of features
names(dataY) <- c("activity")

# Merge all 3 tables to a single one
mergedData1 <- cbind(dataSub, dataY)
mergedData <- cbind(dataX, mergedData1)



#####################################################################################################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
#####################################################################################################


# subset features.txt file has the set of variables that were estimated from these signals are:
# mean() - mean value
# std() - standard deviation
subDataFeatures <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
subDataFeatures

#subset the data frame mergedData by selected names and features
selectedNames <- c(as.character(subDataFeatures), "subject", "activity")
mergedData <- subset(mergedData, select=selectedNames)
dim(mergedData)


#####################################################################################################
# 3. Uses descriptive activity names to name the activities in the data set
#####################################################################################################

mergedData$activity <- as.character(mergedData$activity)
for(i in 1:6) {mergedData$activity[mergedData$activity == i] <- as.character(activityLabels[i,2])}
mergedData$activity <- as.factor(mergedData$activity)


#####################################################################################################
# 4. Appropriately labels the data set with descriptive variable names.
#####################################################################################################

names(mergedData) <- gsub("^t", "time", names(mergedData))                # t -> time
names(mergedData) <- gsub("Acc", "Accelemerometer", names(mergedData))    # Acc -> Accelemerometer
names(mergedData) <- gsub("Gyro", "Gyroscope", names(mergedData))         # Gyro -> Gyroscope
names(mergedData) <- gsub("^f", "frequency", names(mergedData))           # f -> frequency
names(mergedData) <- gsub("mag", "maginitude", names(mergedData))         # mag -> maginitude
names(mergedData) <- gsub("BodyBody", "Body", names(mergedData))          # BodyBody -> Body


#####################################################################################################
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject.
#####################################################################################################

tidyData <- aggregate(. ~subject + activity, mergedData, mean)
tidyData <- tidyData[order(tidyData$subject, tidyData$activity),]
write.table(tidyData, file = "tidydata.txt", row.name = FALSE)
dim(tidyData)
