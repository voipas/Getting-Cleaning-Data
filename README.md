# Getting-Cleaning-Data

The __readme__ document provides the instructions to prepare and clean dataset requested by Coursera - Getting and Cleaning Data - Course Poject:
1) Download and Copy run_analysis.R file to your working directory
2) Download UCI HAR Dataset - (Optional)


The main steps performed by "run_analysis.R" scrip:
1. If required will download UCI HAR Dataset.
2. Reads activities, trainings, test and features data.
3. Merges the training and the test sets to create one data set leveraging rbind function.
4. Extracts only the measurements on the mean and standard deviation for each measurement.
5. Uses descriptive activity names to name the activities in the data set
6. Appropriately labels the data set with descriptive variable names.
7. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
