#Peer assigment

#After downloading the zip file of the data into a directory named:"peer assigment":

#1#

#Merges the training and the test sets to create one data set#

#1.1#

#Reading the data:
#test data

x_test<-read.table("./peer assigment/UCI HAR Dataset/test/X_test.txt")

#train data

x_train<-read.table("./peer assigment/UCI HAR Dataset/train/X_train.txt")

#1.2#
#merging the data to one dataset

all_data<-rbind(x_test,x_train)

#2:Extracts only the measurements on the mean and standard deviation for each measurement.

#2.1#

#getting the columns labels:

features<-read.table("./peer assigment/UCI HAR Dataset/features.txt")

#nameing the columns by the features:

names(all_data)<-features[,2]

#2.2# Extracting the relevants columns:

relevant.features<-grep("mean|std", features$V2)

relevant_data<-all_data[,relevant.features]


#3:Uses descriptive activity names to name the activities in the data set

#3.1 reading the factors for each observation:

y_test<-read.table("./peer assigment/UCI HAR Dataset/test/y_test.txt")
y_train<-read.table("./peer assigment/UCI HAR Dataset/train/y_train.txt")

all_y<-rbind(y_test,y_train)

#3.2 reading the lables

labels<-read.table("./peer assigment/UCI HAR Dataset/activity_labels.txt")

#Labels in y
all_y$activity <- factor(all_y$V1, levels = labels$V1, labels =labels$V2)

#combine the lables with the dataset

relevant_data<-cbind(all_y[,2],relevant_data)

names(relevant_data)[1]<-"Labels"


#4.  Appropriately labels the data set with descriptive variable names.

#4.1 

names(relevant_data) <- gsub("Acc", " Accelerator ", names(relevant_data))

names(relevant_data) <- gsub("Mag", " Magnitude ", names(relevant_data))

names(relevant_data) <- gsub("Gyro", " Gyroskope ", names(relevant_data))

names(relevant_data) <- gsub("^t", " Time ", names(relevant_data))
names(relevant_data) <- gsub("^f", " Frequency ", names(relevant_data))

names(relevant_data) <- gsub("mean()", " Mean ", names(relevant_data))

names(relevant_data) <- gsub("std()", " STD ", names(relevant_data))

names(relevant_data) <- sub("","", names(relevant_data))

names(relevant_data) <- gsub("X", "Axe:X", names(relevant_data))
names(relevant_data) <- gsub("Y", "Axe:Y", names(relevant_data))
names(relevant_data) <- gsub("Z", "Axe:Z", names(relevant_data))

#5.From the data set in step 4, creates a second, independent tidy data set with 
#the average of each variable for each activity and each subject.

#5.1 Getting the subjects data
#test data going first since they were first in the original data

subject_test<--read.table("./peer assigment/UCI HAR Dataset/test/subject_test.txt")

subject_train<--read.table("./peer assigment/UCI HAR Dataset/train/subject_train.txt")

all_subject<-rbind(subject_test,subject_train)

all_subject<-all_subject*(-1)

relevant_data<-cbind(all_subject,relevant_data)

names(relevant_data)[1]<-"participant"

names(relevant_data)[2]<-"activity"

#5.2
library(dtplyr)

tidydata <- data.table(relevant_data)
tidy<-tidydata[, lapply(.SD, mean), by = 'participant,activity']
#sorting data set by participant and by activity
tidy<-tidy[order(tidy$participant, tidy$activity),]
delet<-ls()
delet<-delet[-10]
rm(list=delet)
rm(delet)
write.table(tidy, file = "tidy.txt", row.names = FALSE)

#Done