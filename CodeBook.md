#Getting and Cleaning Data Project CodeBook
=================================================

This file describes the variables and transformations performed by the run_analysis.R cleanup script.

###Input Data
Dataset and reference materials are downloaded manually outside of the script
- Reference data source: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones      
- Project data source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

After checking for the existance of files and before any data analysis begins the relevant files from the *UCI HAR Dataset* directory are read in to apporpriately named data frame as follows:   

Data frame name  |File name                   |Description
---------------- |--------------------------  |--------------------------------------------------------
features         |'features.txt'              |: 561 x 2 - List of all features.
activityType     |'activity_labels.txt'       |: 6 x 2 - Links class labels with their activity name.
subjectTrain     |'train/subject_train.txt'   |: 7352 x 1 - List of subject identifiers training set.
xTrain           |'train/X_train.txt'         |: 7352 x 561 - Training set.
yTrain           |'train/y_train.txt'         |: 7352 x 1 - Training labels.
subjectTest      |'test/subject_test.txt'     |: 2947 x 1 - List of subject identifiers test set.
xTest            |'test/X_test.txt'           |: 2947 x 561 - Test set.
yTest            |'test/y_test.txt'           |: 2947 x 1 - Test labels.

###Transformations
Cleanup begins with creating a clean set of lables from the *features* list but removing all parens, hyphens and commas for each entry. The resulting clean list of labels is stored in a list of 561 elements called *tidyLabels*.  This list will be used to populate the column headers of the xTrain and xTest data frames.

In orer to be able to reference data by column names are assigned to the following data frames:

Data frame name       |Label(s) assigned
--------------------- |------------------------------
activityType          |'activityId' and 'activityType'
subjectTrain          |'subjectId'
xTrain                |Contents of *tidyLables*
yTrain                |'activityId'
subjectTest           |'subjectId'
xTest                 |Contents of *tidyLables*
yTest                 |'activityId'

In order to create a complete picture of the available date the data frames comprising the various test and training data frames need to be aggregated.  This is achieved by first column binding the test and training data individually and then row binding the two together to create the 10299 x 88 *aggregateData* data frame.

Next, the *aggregateData* data frame is modified to contain only the mean and standard deviation columns.  This is done by grep'ping for the appropriate columns that include the Mean, Std, activity or subject.  The descriptive activity types are then merg'ed in to the *aggregateData* data frame to assign the descriptive activity type in *activityType* to each observation based on the *activityId*. Fianlly, the *aggregateData* data frame is arrange'ed to sort the entire set of observations first by *activityId* and then by *subjectId*.  

This completes the cleanup of the original data resulting in a 10299 x 89 *aggregteData* data frame containing the means and standard deviations for all subjects and activities sorted by activity then by subject.

To build the second, independent tidy data set with the average of each variable for each activity and each subject, the summary of means across all columns of the new *aggregateData* data frame is created by omiting the the *activityId*, *activityType* and *subjectId* columns and aggregating by *activityId* and *subjectId*.  Then storing the resulting dataframe in to *tidyData*.  This new data frame is arrange'd to sort by *activityId* and then by *subjectId*.  

This completes the creation of a summarized dataset containing the means of all means and standard deviations for 85 variables sorted by *activityId* and *subjectId* in to a 180 x 88 *tidyData* data frame for the 30 subjects and 6 activities.

###The output
The final *tidyData* is written to the tidyData.txt file.




