library(dplyr)

filename <- "Coursera_DS3_Final.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

##merging data
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
merged <- cbind(Subject, Y, X)

##cleaning data
clean <- merged %>% select(subject, code, contains("mean"), contains("std"))

##assigning names to activities
clean$code <- activities[clean$code, 2]

##labelling dataset
names(clean)[2] = "activity"
names(clean) <- gsub("Acc", "Accelerometer", names(clean))
names(clean) <- gsub("Gyro", "Gyroscope", names(clean))
names(clean) <- gsub("BodyBody", "Body", names(clean))
names(clean) <- gsub("Mag", "Magnitude", names(clean))
names(clean) <- gsub("^t", "Time", names(clean))
names(clean) <- gsub("^f", "Frequency", names(clean))
names(clean) <- gsub("tBody", "TimeBody", names(clean))
names(clean) <- gsub("-mean()", "Mean", names(clean), ignore.case = TRUE)
names(clean) <- gsub("-std()", "STD", names(clean), ignore.case = TRUE)
names(clean) <- gsub("-freq()", "Frequency", names(clean), ignore.case = TRUE)
names(clean) <- gsub("angle", "Angle", names(clean))
names(clean) <- gsub("gravity", "Gravity", names(clean))

##average
clean <- clean %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(clean, "clean.txt", row.name=FALSE)