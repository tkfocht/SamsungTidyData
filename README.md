SamsungTidyData
===============

Scripts and documentation for creating tidy data sets from Samsung accelerometer data


Scripts
=======

* run_analysis.R: This script will build two tidy datasets called samsungdata and samsungdatameans when sourced. It assumes that the Samsung accelerometer data available at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip is unzipped and in the working directory. The script loads both datasets, merges them, and renames variables and columns to be friendlier. It also creates the summary dataset. Both samsungdata and samsungdatameans are described in CodeBook.md.