##########################################################
#  run_analysis.R
#  Author: Leo G Fernandez
#  Date: 22 Feb 2015
#
#
#
#
#########################################################################

pathData <- "./dataset/"

# load required libraries
# library(stringr)
# library(plyr)
library(reshape2)


# Read in file containing trainX data from train data set
dataTrainX <- read.table(paste(pathData,"train/X_train.txt",sep="/"),sep="")
# Read in file containing testX data from test data set
dataTestX <- read.table(paste(pathData,"test/X_test.txt",sep="/"),sep="")



#  1. Merges the training and the test sets to create one data set. 
dataAll <- rbind(dataTrainX,dataTestX)

##########  Read other support files ###################################
# Activity labels, Feature names

# Read in file containing activity class lables and activity names
dataActivityNames <- read.table(paste(pathData,"activity_labels.txt",sep="/"),sep="")
colnames(dataActivityNames) <- c("activity_id","activity")

# Read in file containing list of variable names of each feature vector
dataFeatVars <- read.table(file=paste(pathData,"features.txt",sep="/"),sep="")
# txt_features_info <- scan(file=paste(pathData,"features_info.txt",character(0), sep = "\n")

##########  Rename variables in data set ###################################

# 4.Appropriately label the data set with descriptive variable names.
# Make the variable names provided more manageable by renaming them.
# The feature names supplied contain the characters "()" 
#  e.g: tBodyAcc-mean()-X, tBodyAcc-std()-X, tBodyAcc-energy()-X and so on
# To make it easier for humans to read and machines to process, 
# the feature names (variable names) will be re-written removing the parentheses.
#  tBodyAcc-mean()-X  becomes tBodyAcc-mean-X
#  tBodyAcc-std()-X   	=>  tBodyAcc-std-X
#  tBodyAccMag-mean()	=>  tBodyAccMag-mean
#
# Some feature names contain ",". The commas in feature names are replaced with "." 
# e.g:	fBodyAcc-bandsEnergy()-25,32	=>  fBodyAcc-bandsEnergy()-25_32
#	tBodyGyroJerk-arCoeff()-X,1	=>  tBodyGyroJerk-arCoeff()-X_1	 
#  

# a) Remove all parentheses
dataFeatVars <- as.data.frame(gsub("[\\(\\)]+","",dataFeatVars$V2))
colnames(dataFeatVars) <- c("FeatureName")
# b) Replace comma with underscore character
dataFeatVars <- as.data.frame(gsub(",",".",dataFeatVars$FeatureName))      
colnames(dataFeatVars) <- c("FeatureName")

############ Rename Columns ###################################
# Rename columns to be human readable and easier for machine processing
colnames(dataAll) <- dataFeatVars[,1]

# Extract only the measurements on "mean" and "std" 
# subF <- subset(dataFeatVars, dataFeatVars[,FeatureName] %in% c("mean", "std"), drop = TRUE) 

dataExtracted <- as.data.frame(subset(dataFeatVars, grepl("mean|std", dataFeatVars$FeatureName), drop = TRUE))
colnames(dataExtracted) <- c("FeatureName")
dataExtracted <- as.data.frame(subset(dataExtracted, !grepl("meanFreq", dataExtracted$FeatureName), drop = TRUE))
colnames(dataExtracted) <- c("FeatureName")

########## subF contains the Feture names / variabe names to be extracted to tidy data

# Read in file containing Subject identifiers from train data set
dataSubjectTrain <- read.table(paste(pathData,"train/subject_train.txt",sep="/"),sep="")
colnames(dataSubjectTrain) <- c("subject")
# Read in file containing Subject identifiers from test data set
dataSubjectTest <- read.table(paste(pathData,"test/subject_test.txt",sep="/"),sep="")

colnames(dataSubjectTest) <- c("subject")

# Add a column variable to dataSubjectTrain and dataSubjectTest  
# so that train and test data can be differentiated when the datasets are merged.
dataSubjectTrain <- cbind(dataset="train",dataSubjectTrain)
dataSubjectTest <- cbind(dataset="test",dataSubjectTest)

# Merge the subjects of train and test data into one frame
dataSubjectAll <- rbind(dataSubjectTrain,dataSubjectTest)

# Read in file containing activity data for train data set
dataActivityTrain <- read.table(paste(pathData,"train/y_train.txt",sep="/"),sep="")
colnames(dataActivityTrain) <- c("activity")

# Read in file containing activity data for test data set
dataActivityTest <- read.table(paste(pathData,"test/y_test.txt",sep="/"),sep="")
colnames(dataActivityTest) <- c("activity")

# Merge train and test activity data
dataActivity <- rbind(dataActivityTrain,dataActivityTest)

# 3. Uses descriptive activity names to name the activities in the data set
# Recode activity column - replace activity class codes with corresponding name strings
# Over-write existing column 
dataActivity$activity <-  dataActivityNames[match(as.character(dataActivity$activity),  
				dataActivityNames$activity_id), 'activity']
				dataActivity$activity <- as.factor(dataActivity$activity)
# dataActivity
# str(dataActivity)

# Merge Activity names to combined Subject list
dataSubjectActivityAll <- cbind(dataSubjectAll,dataActivity)

# Bind the Subjects and Activity list with the combined dataset
dataAll <- cbind(dataSubjectActivityAll,dataAll)

# head(dataAll[,1:8])
# tail(dataAll[,1:8])
################# Now we hav ALL the data ###############################

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# Search of "mean" OR "std" in column names

dataSubset <- dataAll[,grepl("dataset|subject|activity|mean|std", colnames(dataAll))]

# Check the dataset
head(dataSubset[,1:6])
tail(dataSubset[,1:6])

# 5. Create an independent tidy data set with the average 
#      of each variable for each activity and subject

dataMelted <- melt(dataSubset,id=c("dataset","subject","activity"))

d1 <- dcast(dataMelted, dataset ~ variable)
d2 <- dcast(dataMelted, subject ~ variable)
d3 <- dcast(dataMelted, activity ~ variable)

d4 <- dcast(dataMelted, activity + subject ~ variable)

d5 <- dcast(dataMelted, dataset + activity + subject ~ variable,mean)

data_mean <- dcast(dataMelted,activity + subject ~ variable,mean)

# Write the tidy data set to a table without row names 
write.table(data_mean,"./tidy_activity_data.txt", row.names = FALSE)

write.table(data_mean,"./tidy_activity_data_row.txt", row.names = TRUE)

## To View the produced output in R:
#  data <- read.table("./tidy_activity_data.txt", header = TRUE)
#  View(data)


