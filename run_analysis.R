##########################################################
#  run_analysis.R
#  Author: Leo G Fernandez
#  Date: 22 Feb 2015
#
#  Script to tidy the data set collected from the
#  "Human Activity Recognition Using Smartphones Data Set"
#  Data can be obtained from:
#  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
#########################################################################

path_data <- "./dataset/"

# load required libraries
library(reshape2)

############### Read Files ###############
# Read in file containing trainX data from train data set
data_TrainX <- read.table(paste(path_data,"train/X_train.txt",sep="/"),sep="")
# Read in file containing testX data from test data set
data_TestX <- read.table(paste(path_data,"test/X_test.txt",sep="/"),sep="")

# Read Activity labels, Feature names files
# Read in file containing activity class lables and activity names
activity_names <- read.table(paste(path_data,"activity_labels.txt",sep="/"),sep="")
colnames(activity_names) <- c("activity_id","activity")

# Read in file containing list of variable names of each feature vector
features <- read.table(file=paste(path_data,"features.txt",sep="/"),sep="")
# txt_features_info <- scan(file=paste(path_data,"features_info.txt",character(0), sep = "\n")

# Read in file containing activity data for train data set
activity_train <- read.table(paste(path_data,"train/y_train.txt",sep="/"),sep="")
colnames(activity_train) <- c("activity")

# Read in file containing activity data for test data set
activity_test <- read.table(paste(path_data,"test/y_test.txt",sep="/"),sep="")
colnames(activity_test) <- c("activity")

# Merge train and test activity data
activity_all <- rbind(activity_train,activity_test)


########## Read file containing subject identifiers
# Read in file containing Subject identifiers from train data set
subject_id_train <- read.table(paste(path_data,"train/subject_train.txt",sep="/"),sep="")
colnames(subject_id_train) <- c("subject")
# Read in file containing Subject identifiers from test data set
subject_id_test <- read.table(paste(path_data,"test/subject_test.txt",sep="/"),sep="")
colnames(subject_id_test) <- c("subject")

# Add a variable called "source" to subject_id_trainand subject_id_test  
# so that train and test data can be differentiated when the datasets are merged.
subject_id_train<- cbind(source="train",subject_id_train )
subject_id_test <- cbind(source="test",subject_id_test)

# Merge the subjects of train and test data into one frame
subject_id_all <- rbind(subject_id_train ,subject_id_test)

# 3. Uses descriptive activity names to name the activities in the data set
# Recode activity column - replace activity class codes with corresponding name strings
# Over-write existing column 
activity_all$activity <-  activity_names[match(as.character(activity_all$activity),  
						  activity_names$activity_id), 'activity']

activity_all$activity <- as.factor(activity_all$activity)
# activity_all
# str(activity_all)

############### Merge datasets ###############

# Merge Activity names to combined Subject list
subject_activity_all <- cbind(subject_id_all,activity_all)

head(subject_activity_all)
tail(subject_activity_all)

#  1. Merge the training and the test sets to create one data set. 
data_all <- rbind(data_TrainX,data_TestX)

# Bind the Subjects and Activity list with the combined dataset
data_all <- cbind(subject_activity_all,data_all)
head(data_all[,1:9])
tail(data_all[,1:9])

################# Now we have ALL the data ###############################

########  Change Feature labels #######
# 4.Appropriately label the data set with descriptive variable names.

# a) Remove all parentheses
features <- as.data.frame(gsub("[\\(\\)]+","",features$V2))
colnames(features) <- c("feature_name")

# b) Replace "-" with underscore character
features <- as.data.frame(gsub("-","_",features$feature_name))      
colnames(features) <- c("feature_name")

# c) Replace comma with underscore character
features <- as.data.frame(gsub(",",".",features$feature_name))      
colnames(features) <- c("feature_name")

# d) Replace "BodyBody" with "Body"
features <- as.data.frame(gsub("BodyBody","Body",features$feature_name))      
colnames(features) <- c("feature_name")

##################################################

############ Rename Columns in data frame ###################################
# Rename columns to be human readable and easier for machine processing

# First 3 columns have been assigned appropriate names: **source**, **subject**, **activity**
# Rename from column 4 to end of columns using the names prepared in frame: **features**

colames(data_all)[c(4:ncol(data_all))] <- as.character(features$feature_name)

# Select subset of columns which contain the measurements on "mean" and "std" 
col_subset <- as.data.frame(subset(features, grepl("mean|std", features$feature_name), drop = TRUE))
colnames(col_subset) <- c("feature_name")
col_subset <- as.data.frame(subset(col_subset, !grepl("meanFreq", col_subset$feature_name), drop = TRUE))
colnames(col_subset) <- c("feature_name")

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# Search of "mean" OR "std" in column names

# Retain only the columns that required columns:  
data_subset <- data_all[,grepl("source|subject|activity|mean|std", colnames(data_all))]
# **NOTE**: Though we include the column 'source' in the subset to indicate 
#           if data is from 'train or 'test' set, this column is not used in the final output.
#           However, the column is available in the subsetted data just in case we
#           will to work with 'train' and 'test' sets.

# Check the dataset
head(data_subset[,1:6])
tail(data_subset[,1:6])

# 5. Create an independent tidy data set with the average 
#      of each variable for each activity and subject

data_melted <- melt(data_subset,id=c("source","subject","activity"))

data_mean <- dcast(data_melted,activity + subject ~ variable,mean)

# Write the tidy data set to a table without row names 
write.table(data_mean,"./tidy_activity_data.txt", row.names = FALSE)

## To View the produced output in R:
# data <- read.table("./tidy_activity_data.txt", header = TRUE)
# View(data)


