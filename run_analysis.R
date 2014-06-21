library(reshape2)

#This function loads a single data set (according to datasettag) of the
#Samsung data located at filepath.
single_dataset <- function(filepath, datasettag, featurenames) {
  #Get the subject id for each observation
  subjects_filehandle <- paste(c(filepath, "/", datasettag, "/subject_", datasettag, ".txt"), collapse = "")
  dataset_subjects <- read.table(subjects_filehandle)
  dataset_subjects <- as.data.frame(dataset_subjects)
  names(dataset_subjects) <- c("subjectid")
  
  #Get the activity code for each observation
  activity_codes_filehandle <- paste(c(filepath, "/", datasettag, "/y_", datasettag, ".txt"), collapse = "")
  dataset_activity_codes <- read.table(activity_codes_filehandle)
  dataset_activity_codes <- as.data.frame(dataset_activity_codes)
  names(dataset_activity_codes) <- c("activitycode")

  #Get all of the measurements for each observation
  measurements_filehandle <- paste(c(filepath, "/", datasettag, "/X_", datasettag, ".txt"), collapse = "")
  dataset_measurements <- read.table(measurements_filehandle)
  dataset_measurements <- as.data.frame(dataset_measurements)
  names(dataset_measurements) <- featurenames
  
  #Combine into a single data frame and return
  dataset <- data.frame(dataset_subjects,
                        dataset_activity_codes,
                        dataset_measurements)  
  dataset
}

#This function loads the names of the 'features' or measurements for the
#Samsung data located at filepath. These names are read from the file
#and then manipulated to be friendlier to read.
feature_names <- function(filepath) {
  features_filehandle <- paste(c(filepath, "/features.txt"), collapse = "")
  features_table <- read.table(features_filehandle)
  features <- features_table$V2
  
  pattern <- "^(.*)-(.*)\\(\\)-(.*)$"
  features <- gsub(pattern, "\\2_of_\\1_on_\\3", features, fixed = FALSE)
  features
}

#This function builds a data frame relating activity codes to the activity names
#(ie, WALKING, etc.) for the Samsung data located at filepath.
activities <- function(filepath) {
  activitycodes <- read.table(paste(c(filepath, "/activity_labels.txt"), collapse = ""))
  activitycodes <- as.data.frame(activitycodes)
  names(activitycodes) <- c("activitycode", "activityname")
  activitycodes
}

#This function loads both training and test data for the Samsung data located
#at filepath and combines them into a single dataset. It replaces the activity
#codes with more readable activity names, and it removes all measurements that
#are not means or standard deviations.
merged_dataset <- function(filepath) {
  #Load measurement names
  features <- feature_names(filepath)
  
  #Build full dataset
  test_dataset <- single_dataset(filepath, "test", features)
  train_dataset <- single_dataset(filepath, "train", features)
  combined_dataset <- rbind(test_dataset, train_dataset)

  #Replace activity codes with activity names
  activitycodes <- activities(filepath)
  combined_dataset <- merge(combined_dataset, activitycodes,
                            by.x = "activitycode", by.y = "activitycode")
  
  #Discard unwanted columns
  columns_to_keep <- c(which(grepl("subjectid", names(combined_dataset))),
                       which(grepl("activityname", names(combined_dataset))),
                       which(grepl("^mean_of", names(combined_dataset))),
                       which(grepl("^std_of", names(combined_dataset))))
  combined_dataset <- combined_dataset[,columns_to_keep]

  combined_dataset
}

#This function builds an independent summary dataset for the Samsung data that
#averages each measurement for each grouping of subject and activity.
summarized_dataset <- function(dataset) {
  melted_set <- melt(dataset, id.vars=c('subjectid','activityname'))
  cast_set <- dcast(melted_set, subjectid + activityname ~ variable, mean)
  names(cast_set)[3:50] <- sapply(names(cast_set[3:50]), function(n) paste(c("mean_of_", n), collapse=""))
  cast_set
}

samsungdata <- merged_dataset("") #Assumes data is in current working directory
samsungdatameans <- summarized_dataset(samsungdata)