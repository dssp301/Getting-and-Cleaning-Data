# This script will cleanup the data from the UCI HAR Dataset downloaded from 
#        https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# The final out put will be an independent tidy data set with the average of each 
# variable for each activity and each subject. 

# The following interim steps will aid in achieving the final output
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 


# Clean up workspace
rm(list=ls())

# load library that has tools for splitting, applying and combining data
library("plyr")

# 1. Merge the training and the test sets to create one data set.

# Make sure that all of the necessary files for the UCI HAR Dataset exist in the proper locations
directory <- "./UCI HAR Dataset"
featuresFile <- paste(directory, '/features.txt', sep="")
activityTypeFile <- paste(directory, '/activity_labels.txt', sep="")
subjectTrainFile <- paste(directory, '/train/subject_train.txt', sep="")
xTrainFile <- paste(directory, '/train/X_train.txt', sep="")
yTrainFile <- paste(directory, '/train/y_train.txt', sep="")
subjectTestFile <- paste(directory, '/test/subject_test.txt', sep="")
xTestFile <- paste(directory, '/test/X_test.txt', sep="")
yTestFile <- paste(directory, '/test/y_test.txt', sep="")
outputTidyDataFile <- "./tidyData.txt"
if(!file.exists(directory)) stop("Directory ", directory, " not found!")
if(!file.exists(featuresFile)) stop("File", featuresFile, " not found!")
if(!file.exists(activityTypeFile)) stop("File", activityTypeFile, " not found!")
if(!file.exists(subjectTrainFile)) stop("File", subjectTrainFile, " not found!")
if(!file.exists(xTrainFile)) stop("File", xTrainFile, " not found!")
if(!file.exists(yTrainFile)) stop("File", yTrainFile, " not found!")
if(!file.exists(subjectTestFile)) stop("File", subjectTestFile, " not found!")
if(!file.exists(xTestFile)) stop("File", xTestFile, " not found!")
if(!file.exists(yTestFile)) stop("File", yTestFile, " not found!")

# Read in the data from files
features <- read.table(featuresFile, header=FALSE)
activityType <- read.table(activityTypeFile, header=FALSE)
subjectTrain <- read.table(subjectTrainFile, header=FALSE)
xTrain <- read.table(xTrainFile, header=FALSE)
yTrain <- read.table(yTrainFile, header=FALSE)
subjectTest <- read.table(subjectTestFile, header=FALSE)
xTest <- read.table(xTestFile, header=FALSE)
yTest <- read.table(yTestFile, header=FALSE)


# Tidy up the feature names by removing "-", "(", ")" and ",".
#   Also capitalize each individual word that is not the first word in a feature name.
tidyLabels <- lapply(features[,2], gsub, pattern = "[-(),]+(\\w)", replacement = "\\U\\1", perl=TRUE)
tidyLabels <- lapply(tidyLabels , gsub, pattern = "[-(),]+$", replacement = "", perl=TRUE)

# Assigin column names to the data 
colnames(activityType) <- c('activityId','activityType')
colnames(subjectTrain) <- "subjectId"
colnames(xTrain) <- tidyLabels
colnames(yTrain) <- "activityId"
colnames(subjectTest) <- "subjectId"
colnames(xTest) <- tidyLabels
colnames(yTest) <- "activityId"

# merge the labeled data in to a single data set
aggregateData <- rbind(cbind(yTrain, subjectTrain, xTrain), cbind(yTest, subjectTest, xTest))


# 2. Extract only the measurements on the mean and standard deviation for each measurement. 

# collect all of the column names
names  <- colnames(aggregateData)

# Select only the columns that are needed (i.e. activityID, subjectID, all of the 
#    means and all of the standard deviations)
aggregateData <- aggregateData[grepl("(activity|subject|Mean|Std)", names, perl = TRUE)]


# 3. Use descriptive activity names to name the activities in the data set

# Join the descriptive activity types to the selected data
aggregateData <- merge(activityType, aggregateData, by='activityId', all.x=TRUE)

# rearrange the rows to present the final tidy data sorted by activity and subject
aggregateData <- arrange(aggregateData, activityId, subjectId)


# 5. Create a second, independent tidy data set with the average of each variable 
#    for each activity and each subject. 

# Create the summary dataset with the means of each variable for each activity and each subject
# tidyData <- aggregate(within(aggDataWithoutActivityType, rm(activityId, subjectId)), 
tidyData <- aggregate(within(aggregateData, rm(activityId, activityType, subjectId)), 
                      by=list(activityId=aggregateData$activityId, 
                              subjectId = aggregateData$subjectId), mean)

# Precaution: rearrange the rows to present the final tidy data sorted by activity and subject
tidyData <- arrange(tidyData, activityId, subjectId)

# Write the tidyData set to the output file
write.table(tidyData, outputTidyDataFile, row.names=FALSE, sep='\t')


stop("ALL GOOD!")



