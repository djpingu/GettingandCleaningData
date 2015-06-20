library(dplyr)

## Loads all data into R

trainX <- read.table("./Rdata/train/X_train.txt")
testX <- read.table("./Rdata/test/X_test.txt")
trainY <- read.table("./Rdata/train/Y_train.txt")
testY <- read.table("./Rdata/test/Y_test.txt")
trainSubject <- read.table("./Rdata/train/subject_train.txt")
testSubject <- read.table("./Rdata/test/subject_test.txt")        
LabelsX <- read.table("./Rdata/features.txt")
LabelsY <- read.table("./Rdata/activity_labels.txt")


## 1. Merge the training and the test sets to create one data set.

allDataX <- rbind(trainX, testX)
allDataY <- rbind(trainY, testY)
allDataSubject <- rbind(trainSubject, testSubject)

## 2. Extract only the measurements on the mean and standard deviation for each measurement.

names(allDataX) <- LabelsX[,2]
filterColMean <- grep("mean()", names(allDataX), fixed=TRUE)
filterColStd <- grep("std()", names(allDataX), fixed=TRUE)
filterCol <- sort(c(filterColMean, filterColStd))
allDataX <- allDataX[,filterCol]

## 3. Use descriptive activity names to name the activities in the data set

colnames(allDataY) <- "Activity"
colnames(allDataSubject) <- "Subject"

## 5. From the data set in step 4, creates a second, independent tidy data set with 
##    the average of each variable for each activity and each subject.

ALL <- cbind(allDataX, allDataY, allDataSubject)
TIDY <- aggregate(allDataX, by=list(allDataSubject$Subject, allDataY$Activity), FUN=mean)
colnames(TIDY)[colnames(TIDY)=="Group.1"] <- "Subject"
colnames(TIDY)[colnames(TIDY)=="Group.2"] <- "Activity"

## 4. Appropriately label the data set with descriptive variable names. 

TIDY$Activity[TIDY$Activity == 1] = "WALKING"
TIDY$Activity[TIDY$Activity == 2] = "WALKING_UPSTAIRS"
TIDY$Activity[TIDY$Activity == 3] = "WALKING_DOWNSTAIRS"
TIDY$Activity[TIDY$Activity == 4] = "SITTING"
TIDY$Activity[TIDY$Activity == 5] = "STANDING"
TIDY$Activity[TIDY$Activity == 6] = "LAYING"
TIDY$Activity <- as.factor(TIDY$Activity)

write.table(TIDY, file = "./Rdata/TidyData.txt")


