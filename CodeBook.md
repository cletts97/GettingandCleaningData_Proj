# CodeBook for Tidy Data Set

## Overview
This CodeBook describes the tidy dataset (`Output/tidy_dataset.txt`) created by the `run_analysis.R` script from the UCI Human Activity Recognition (HAR) Dataset. The dataset originates from accelerometer and gyroscope measurements collected using a Samsung Galaxy S II smartphone. The script processes the raw data to produce a tidy dataset with averages of selected features for each subject and activity combination.

## Data Source
- **Dataset**: UCI Human Activity Recognition Using Smartphones Dataset
- **URL**: [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
- **Description**: The data was collected from 30 volunteers (aged 19-48) performing six activities while wearing a smartphone on their waist. The smartphone’s embedded accelerometer and gyroscope captured 3-axial linear acceleration and angular velocity at 50 Hz. The data was preprocessed into a 561-feature vector per observation, split into training (70%) and test (30%) sets.

## Original Files Used
- `features.txt`: List of 561 feature names for the measurement data.
- `activity_labels.txt`: Mapping of activity codes (1-6) to descriptive activity names.
- `train/subject_train.txt`: Subject IDs for training data (1-30).
- `train/y_train.txt`: Activity codes for training data.
- `train/X_train.txt`: 561-feature measurement data for training.
- `test/subject_test.txt`: Subject IDs for test data.
- `test/y_test.txt`: Activity codes for test data.
- `test/X_test.txt`: 561-feature measurement data for test.

## Variables in the Tidy Dataset
The tidy dataset (`tidy_dataset.txt`) contains 68 variables, including two identifier columns and 66 measurement columns averaged by subject and activity.

### Identifier Variables
1. **Subject**
   - **Type**: Integer
   - **Range**: 1 to 30
   - **Description**: Unique identifier for each of the 30 volunteers who performed the activities.

2. **Activity**
   - **Type**: Character
   - **Values**: "WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"
   - **Description**: The activity performed by the subject during the measurement period.

### Measurement Variables (66 Columns)
- **Format**: Each column name starts with "Mean of " followed by a cleaned feature name.
- **Description**: These are the averages of the original features containing "mean" or "std" in their names, computed for each Subject-Activity combination.
- **Units**: The original features are normalized to [-1, 1]; averages retain this scale.
- **Count**: 66 variables (filtered from the original 561 features).
- **Examples**:
  - `Mean of Time BodyAcc mean X`: Average time-domain body acceleration mean along the X-axis.
  - `Mean of Time BodyAcc std Y`: Average time-domain body acceleration standard deviation along the Y-axis.
  - `Mean of FFT BodyGyro std Z`: Average frequency-domain (Fast Fourier Transform) gyroscope standard deviation along the Z-axis.
  - `Mean of Angle tBodyAccMean gravity`: Average angle between the time-domain body acceleration mean and gravity.

- **Naming Convention**:
  - "Time" prefix: Indicates time-domain signals (originally `t` in `features.txt`).
  - "FFT" prefix: Indicates frequency-domain signals (originally `f` in `features.txt`).
  - "BodyAcc": Body acceleration from the accelerometer.
  - "GravityAcc": Gravity acceleration from the accelerometer.
  - "BodyGyro": Angular velocity from the gyroscope.
  - "mean": Mean value of the signal.
  - "std": Standard deviation of the signal.
  - "X", "Y", "Z": The 3-axial directions.
  - "Angle": Angle measurements between vectors.

- **Full List**: See the output file `tidy_dataset.txt` for all 66 variable names, or refer to `features.txt` for the original 561 features, filtered to those containing "mean" or "std".

## Transformations
The `run_analysis.R` script performs the following steps to transform the raw data into the tidy dataset:

1. **Merging Training and Test Sets**
   - Loaded training data (`subject_train.txt`, `y_train.txt`, `X_train.txt`) and test data (`subject_test.txt`, `y_test.txt`, `X_test.txt`) using the `load_data()` function.
   - Combined subject IDs, activity codes, and feature data into single data frames for training and test sets.
   - Merged the training and test data frames by row-binding (`bind_rows`) into `full_data`.

2. **Extracting Mean and Standard Deviation Measurements**
   - Filtered `full_data` to keep only columns with "mean" or "std" in their names (case-insensitive), plus `Subject` and `Activity`.
   - Reduced the original 561 features to 66 (those related to mean and standard deviation).

3. **Adding Descriptive Activity Names**
   - Joined `full_data` with `activity_labels.txt` using `ActivityCode` to replace numeric codes (1-6) with descriptive names (e.g., "WALKING").
   - Dropped the `ActivityCode` column, retaining only the `Activity` column.

4. **Labeling with Descriptive Variable Names**
   - Applied the following transformations to column names in `full_data`:
     - Replaced `...` with a space (`gsub("\\.\\.\\.", " ", ...)`).
     - Replaced `.` with a space (`gsub("\\.", " ", ...)`).
     - Removed trailing spaces (`gsub(" $", "", ...)`).
     - Replaced `^t` with "Time " (`gsub("^t", "Time ", ...)`).
     - Replaced `^f` with "FFT " (`gsub("^f", "FFT ", ...)`).
     - Capitalized "angle" to "Angle" (`gsub("^(angle)", "Angle", ...)`).
   - Resulting names are human-readable (e.g., `tBodyAcc-mean()-X` becomes `Time BodyAcc mean X`).

5. **Creating the Tidy Dataset**
   - Grouped `full_data` by `Subject` and `Activity`.
   - Computed the mean of each measurement column using `summarise(across(...))`.
   - Prefixed each measurement column with "Mean of " to indicate averaging (e.g., `Time BodyAcc mean X` becomes `Mean of Time BodyAcc mean X`).
   - Ungrouped the data to produce a flat, tidy dataset (`tidy_data`).

6. **Output**
   - Saved `tidy_data` to `Output/tidy_dataset.txt` as a space-separated text file without row names.

## Tidy Dataset Structure
- **Rows**: 180 (30 subjects × 6 activities).
- **Columns**: 68 (2 identifiers + 66 averaged measurements).
- **Format**: Each row represents a unique Subject-Activity combination, with columns containing the mean values of the selected features.

## Notes
- The script assumes the UCI HAR Dataset is unzipped in the working directory with the structure `UCI HAR Dataset/train/` and `UCI HAR Dataset/test/`.
- The `dplyr` package is required to run this script.
- The tidy dataset adheres to tidy data principles: each variable is a column, each observation (Subject-Activity pair) is a row, and each type of observational unit forms a single table.

## Author
- **Name**: Charlie Letts
- **Date**: 05/03/2025