fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, "Dataset.zip")
library(utils) 
unzip("Dataset.zip")
files <- list.files("UCI HAR Dataset", recursive = TRUE)
#reading training and test data
ActivityTest <- read.table(file.path("UCI HAR Dataset","test","y_test.txt"), header = FALSE)
ActivityTrain <- read.table(file.path("UCI HAR Dataset","train","y_train.txt"), header = FALSE)
SubjectTest <- read.table(file.path("UCI HAR Dataset","test","subject_test.txt"), header = FALSE)
SubjectTrain <- read.table(file.path("UCI HAR Dataset","train","subject_train.txt"), header = FALSE)
FeaturesTest <- read.table(file.path("UCI HAR Dataset","test","X_test.txt"), header = FALSE)
FeaturesTrain <- read.table(file.path("UCI HAR Dataset","train","X_train.txt"), header = FALSE)

# Part 1. Merge training and test data sets:
subject <- rbind(SubjectTest,SubjectTrain)
activity <- rbind(ActivityTest,ActivityTrain)
feature <- rbind(FeaturesTest,FeaturesTrain)
names(subject) <- c("subject")
names(activity) <- c("activity")
FeatureNames <- read.table(file.path("UCI HAR Dataset","features.txt"), header = FALSE)
names(feature) <- FeatureNames$V2
data <- cbind(subject,activity,feature)

# Part 2: extract only mean () and sd() measures
names(data)
data <- data[(grep("mean\\(\\)|std\\(\\)",names(data)))]
data <- cbind(subject,activity,data)

# Part 3: descriptive activity labeling

data$activity <- factor(data$activity)
ActivityLables <- read.table(file.path("UCI HAR Dataset","activity_labels.txt"),header = FALSE)
levels(data$activity) <- ActivityLables$V2
head(data$activity,35)

#Part 4: Appropriately naming the dataset
names(data)
names(data) <- gsub("^f","Frequency" ,names(data))
names(data) <- gsub("^t","Time" ,names(data))
names(data) <- gsub("BodyBody","Body" ,names(data))
names(data) <- gsub("Acc","Accelerometer" ,names(data))
names(data) <- gsub("Gyro","Gyroscope" ,names(data))
names(data) <- gsub("Mag","Magnitude" ,names(data))

#Part 5: tidy dataset
library(plyr)
data2 <- aggregate(.~ subject+activity, data, mean)
data2 <- arrange(data2, subject , activity)
write.table(data2, file= "tidydata.txt", row.names = FALSE, sep = "\t")
