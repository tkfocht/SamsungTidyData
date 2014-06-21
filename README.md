SamsungTidyData
===============

Scripts and documentation for creating tidy data sets from Samsung accelerometer data


Scripts
=======

* run_analysis.R: This script will build two tidy datasets called samsungdata and samsungdatameans when sourced. It assumes that the Samsung accelerometer data available at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip is unzipped and in the working directory. The script loads both datasets, merges them, and renames variables and columns to be friendlier. It also creates the summary dataset. Both samsungdata and samsungdatameans are described in CodeBook.md.

Transformation processes
------------------------

The samsungdata dataset is built in run\_analysis.R according to the following steps:

* Each individual dataset (train and test) is built into a data frame. The subject\_ (subject ids), y\_ (activity codes), and X\_ (measurements) text files are loaded. The corresponding lines of each file are column-bound together to form a single row in the data frame.

* The train and test datasets are concatenated to form a single combined data frame.

* The activity codes are replaced with readable activity names from the lookup in features.txt.

* Measurements that are not of mean or standard deviation of features are discarded. There are measurements that contain the word "mean" within their name but are still discarded. This is because their feature name contains "mean" and not because they themselves are a mean value.


The samsungdatameans dataset is then created by reshaping the samsungdata dataset according to the following steps:

* A melted copy of the samsungdata dataset is created using the subjectid and activityname as identifier fields. This melted dataset is long, and contains a row for every measurement, identifying its subjectid, activityname, measurement name, and value.

* The melted dataset is cast into a summarized form. The observations are grouped by subjectid + activityname and each variable is averaged.

* The resulting columns in the recasted dataset are renamed mean_\of\_<original name> to make it clear that they are the means of the original data.