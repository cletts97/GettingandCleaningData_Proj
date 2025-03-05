# ==============================================================================
# Script Name: run_analysis.R
#
# Author: Charlie Letts
# Date: 05/03/2025
#
# Dataset: "/UCI HAR Dataset" - This is data collected from the accelerometers from the Samsung Galaxy S smartphone.A full description is available at the site where the data was obtained:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#
#
# Script Goals:
#
# 1. Merges the training and the test sets to create one dataset.
# 
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 
# 4. Uses descriptive activity names to name the activities in the dataset
# 
# 5. Appropriately labels the dataset with descriptive variable names. 
# 
# 6. From the dataset in step 4, creates a second, independent tidy dataset with the average of each variable for each activity and each subject.
# ==============================================================================

library(dplyr)

# Read in the vector of features and the activity labels. Name the columns appropriately.
features <- read.table("UCI HAR Dataset/features.txt")[,2]
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("ActivityCode", "Activity"))

# This function loads all the relevant data of the set including the subject vector 
# which identifies which subject the feature values refer to in that period, the
# ID of the activity being performed in that period, and the feature data.
# This are then merged together by binding the columns.
load_data <- function(data_path, train_or_test) {
        subject <- read.table(file.path(data_path, paste0("subject_", train_or_test, ".txt")), col.names = "Subject")
        activity <- read.table(file.path(data_path, paste0("y_", train_or_test, ".txt")), col.names = "ActivityCode")
        features_data <- read.table(file.path(data_path, paste0("X_", train_or_test, ".txt")), col.names = features)
        
        data <- bind_cols(subject, activity, features_data)
        return(data)
}

# Use the function created above to load both the train and test datasets,
train_data <- load_data("UCI HAR Dataset/train/", "train")
test_data <- load_data("UCI HAR Dataset/test/", "test")

# Merge the two datasets by binding their rows.
full_data <- bind_rows(train_data, test_data)

# Add an activity_labels column for readability using the activity_labels.txt data.
# Remove all columns which don't include "mean" or "std" in their name (excluding Subject and Activity).
# Note, the ActivityCode column is also removed here as we now have the Activity column.
full_data <- full_data %>%
        left_join(activity_labels, by = "ActivityCode") %>%
        select(Subject, Activity, matches("mean|std", ignore.case = TRUE))

# Clean up the variable names for better readability.
colnames(full_data) <- gsub("\\.\\.\\.", " ", colnames(full_data))
colnames(full_data) <- gsub("\\.", " ", colnames(full_data))
colnames(full_data) <- gsub(" $", "", colnames(full_data))
colnames(full_data) <- gsub("^t", "Time ", colnames(full_data))
colnames(full_data) <- gsub("^f", "FFT ", colnames(full_data))
colnames(full_data) <- gsub("^(angle)", "Angle", colnames(full_data))

# This is the answer to step 5 of the project. A new dataset is created by grouping
# the dataset on Subject and Activity, and returning the mean of each feature, for each
# Subject/Activity combination.
tidy_data <- full_data %>%
        group_by(Subject, Activity) %>%
        summarise(across(everything(), mean, .names = "Mean of {.col}")) %>%
        ungroup()

# The new dataset is then outputted to a file as instructed.
write.table(tidy_data, "Output/tidy_dataset.txt", row.name = FALSE)