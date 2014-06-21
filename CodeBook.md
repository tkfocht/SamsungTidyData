samsungdata
===========

samsungdata contains all observations of mean and standard deviation measurements taken from the Samsung accelerometer data available at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and described at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. It contains both the training and test datasets.

Fields
------

Each row in samsungdata contains the following fields:

* subjectid: This field is the human subject id for the observation. It is taken from the subject\_test.txt or subject\_train.txt from each dataset. This field takes on integer values from 1 to 30.

* activityname: This field is the activity the human subject was performing during the observation. It takes the values LAYING, SITTING, STANDING, WALKING, WALKING\_DOWNSTAIRS, and WALKING\_UPSTAIRS. For each observation, this field is based on the value in y\_train.txt or y\_test.txt, then transformed to its readable form using the code lookup in features.txt.

* mean\_of\_<Samsung feature name>\_on\_<axis>: For each measured feature where the Samsung data includes mean values, the samsungdata data set includes three fields, one for each of the X, Y, and Z axes. This field contains the recorded mean of the measured feature and the value is taken directly from the base dataset. The name of the field from the base dataset is changed to the format used in samsungdata for better readability.
	
* std\_of\_<Samsung feature name>\_on\_<axis>: For each measured feature where the Samsung data includes standard deviation values, the samsungdata data set includes three fields, one for each of the X, Y, and Z axes. This field contains the recorded standard deviation of the measured feature and the value is taken directly from the base dataset. The name of the field from the base dataset is changed to the format used in samsungdata for better readability.

The features that have mean and standard deviation data and are therefore included in the samsungdata dataset are:

* tBodyAcc
* tGravityAcc
* tBodyAccJerk
* tBodyGyro
* tBodyGyroJerk
* fBodyAcc
* fBodyAccJerk
* fBodyGyro

The definitions and derivations of each of these features is described in the features\_info.txt file of the original Samsung dataset.

Transformation process
----------------------

The samsungdata dataset is built in run\_analysis.R according to the following steps:

* Each individual dataset (train and test) is built into a data frame. The subject\_ (subject ids), y\_ (activity codes), and X\_ (measurements) text files are loaded. The corresponding lines of each file are column-bound together to form a single row in the data frame.

* The train and test datasets are concatenated to form a single combined data frame.

* The activity codes are replaced with readable activity names from the lookup in features.txt.

* Measurements that are not of mean or standard deviation of features are discarded. There are measurements that contain the word "mean" within their name but are still discarded. This is because their feature name contains "mean" and not because they themselves are a mean value.


samsungdatameans
================

The samsungdatameans dataset is a summary dataset of the samsungdata dataset described above. It provides mean values for each measurement, grouped by subjectid and activityname.

Fields
------

Each row in the samsungdatameans dataset contains the following fields:

* subjectid: This field is the human subject id for the row.

* activityname: This field is the activity for the row.

* mean\_of\_<measurement name from samsungdata>: The mean value for the measurement for the given subjectid and activityname.

	
Transformation process
----------------------

The samsungdatameans dataset is created by reshaping the samsungdata dataset according to the following steps:

* A melted copy of the samsungdata dataset is created using the subjectid and activityname as identifier fields. This melted dataset is long, and contains a row for every measurement, identifying its subjectid, activityname, measurement name, and value.

* The melted dataset is cast into a summarized form. The observations are grouped by subjectid + activityname and each variable is averaged.

* The resulting columns in the recasted dataset are renamed mean_\of\_<original name> to make it clear that they are the means of the original data.