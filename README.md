# JHU - Getting and Cleaning Data Course Project

## Overview
This repository contains an R script (`run_analysis.R`) that processes the UCI Human Activity Recognition (HAR) Dataset to create a tidy dataset for analysis. The dataset, collected from Samsung Galaxy S II smartphone accelerometers and gyroscopes, represents measurements from 30 subjects performing six activities. The script fulfills the requirements of a data cleaning project, producing a tidy dataset with averaged measurements for each subject and activity combination.

### Project Goals
The purpose of this project is to demonstrate the ability to collect, work with, and clean a dataset. The script achieves the following:
1. Merges the training and test sets into one dataset.
2. Extracts only the measurements on the mean and standard deviation.
3. Uses descriptive activity names for the activities.
4. Labels the dataset with descriptive variable names.
5. Creates a second, independent tidy dataset with the average of each variable for each activity and subject.

### Repository Contents
- **`run_analysis.R`**: The main R script that processes the UCI HAR Dataset and generates the tidy dataset.
- **`Output/tidy_dataset.txt`**: The resulting tidy dataset, a space-separated text file containing averaged measurements.
- **`CodeBook.md`**: A detailed description of the tidy dataset’s variables, data source, and transformations performed by the script.
- **`README.md`**: This file, providing an overview and instructions for the repository.

### Prerequisites
- **R**: Version 4.0 or higher recommended.
- **R Package**: `dplyr` (install with `install.packages("dplyr")`).
- **Dataset**: The UCI HAR Dataset, downloadable from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

### How to Run the Script
1. **Download the Dataset**:
   - Download the UCI HAR Dataset from the link above.
   - Unzip it into your R working directory. The folder structure should include `UCI HAR Dataset/train/` and `UCI HAR Dataset/test/`.

2. **Set Up the Environment**:
   - Open R or RStudio.
   - Ensure `dplyr` is installed: `install.packages("dplyr")`.
   - Set your working directory to the location containing the `UCI HAR Dataset/` folder (e.g., `setwd("/path/to/your/directory")`).

3. **Run the Script**:
   - Place `run_analysis.R` in your working directory.
   - Execute the script in R: `source("run_analysis.R")`.
   - The script will:
     - Load and merge the training and test data.
     - Process the data as per the project goals.
     - Output the tidy dataset to `Output/tidy_dataset.txt`.

4. **Verify Output**:
   - Check the `Output/` folder for `tidy_dataset.txt`.
   - The file should have 180 rows (30 subjects × 6 activities) and 68 columns (2 identifiers + 66 measurements).

### Script Workflow
- **Loading Data**: The `load_data()` function reads subject IDs, activity codes, and feature measurements from the `train/` and `test/` subdirectories, combining them into data frames.
- **Merging**: Training and test data are row-bound into a single dataset (`full_data`).
- **Filtering**: Only columns with "mean" or "std" in their names are retained, reducing 561 features to 66.
- **Activity Naming**: Numeric activity codes are replaced with descriptive names (e.g., "WALKING") using `activity_labels.txt`.
- **Variable Naming**: Feature names are cleaned (e.g., `tBodyAcc-mean()-X` becomes `Time BodyAcc mean X`) for readability.
- **Tidy Dataset Creation**: The data is grouped by `Subject` and `Activity`, and means are calculated for each feature, producing `tidy_data`.
- **Output**: The tidy dataset is saved as `tidy_dataset.txt`.

### Connection to Project Requirements
- The script is self-contained, requiring only the UCI HAR Dataset and `dplyr`.
- It processes the raw data into a tidy format, adhering to tidy data principles: each variable is a column, each observation (Subject-Activity pair) is a row, and all data is in one table.
- The `CodeBook.md` complements the script by documenting the transformations and variables in detail.

### Author
- **Name**: Charlie Letts
- **Date**: 05/03/2025

### Notes
- Full details about the dataset and transformations are in `CodeBook.md`.
- For more information on the original dataset, see [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).