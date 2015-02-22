*run_analysis.R* - **R Programming script**

Human Activity Recognition Using Smartphones Data Set  
====================================

Script to tidy the data for analysis
------------------------------------

The Human Activity Recognition data set contains recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.<sup>1</sup>

The experiments were carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist.

An embedded accelerometer and gyroscope captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments were video-recorded and the data labeled  manually.

The dataset was randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

## Input Data Set Files:

- README.txt: General information about the data set
- features.txt: List of all features.
- features_info.txt: Information about the variables used on the feature vector.
- activity_labels.txt: Links the class labels with their activity name.
- train/X_train.txt: Training set.
- train/y_train.txt: Training labels.
- train/subject_train.txt: Each row identifies (1-30) the subject who performed the activity.
- test/X_test.txt: Test set. 
- test/y_test.txt: Test labels.
- test/subject_test.txt: Each row identifies (1-30) the subject who performed the activity


## Function of the script:

The obtained data set is not in a form suitable for processing. The data is not normalized and is spread across disparate and directories. The variable names attached to the data contain characters that could choke an R script (eg: "(),-" etc..). The variable names are also not easy to read.

The run_analysis.R script reads data from the "Human Activity Recognition Using Smartphones Dataset"<sup>2</sup> and produces a tidy data set using improved variable naming convention and reshaping the data so that it is suitable  for further analysis. 

The file *CodeBook.md* shows the transformations applied to the original variable names and shows the variabe names used in the output file.

The file *tidy_activity_data.txt* contains the output produced when the R script is run.

## Requirements:

        



## Acknowledgements:

Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.

## License:

The run_analysis.R script is free to use and modify.

Restrictions (if any) for re-distribution of this script is governed by the terms of the *Getting and Cleaning Data Course Project* conducted at **COURSERA**.<sup>3</sup>

The data file "tidy_activity_data.txt", if used to produce work for any publications must be acknowledge and reference the source of the original data set.<sup>4</sup> 

This script and the dataset output by it, is distributed AS-IS and no responsibility implied or explicit can be addressed to the author for its use or misuse.

----------------------------
Leo G Fernandez, Feb 2015


## Footnotes

1. UCI - Center for Machine Learning and Intelligent Systems. http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
2. Download link to zip file of the data is: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
3. https://class.coursera.org/getdata-011
4. Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.
