Getting and Cleaning Data Project
=================================

The run_analysis.R script in this repository will cleanup the data from the UCI HAR Dataset 
downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
and create an independent tidy data set with the average of each variable for each activity and subject.
The tidy data set will be written to an output file called tidyData.txt.

The following steps in the script will aid in achieving the cleanup and summarization:
    1. Merge the training and the test data sets to create one aggregate data set.
    2. Extract only the measurements on the mean and standard deviation for each measurement. 
    3. Use descriptive activity names to name the activities in the data set
    4. Appropriately label the data set with descriptive activity names. 

The CodeBook.md file will describe the variables and transformations performed during the cleanup.

--


