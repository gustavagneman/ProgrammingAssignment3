download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "C:/Users/kmw793/Desktop/DataScience/UCI HAR Dataset")
setwd("C:/Users/kmw793/Desktop/DataScience/UCI HAR Dataset")

features <- read.csv('C:/Users/kmw793/Desktop/DataScience/UCI HAR Dataset/features.txt', header = FALSE, sep = ' ')
features <- as.character(features[,2])

data.train.x <- read.table('C:/Users/kmw793/Desktop/DataScience/UCI HAR Dataset/train/X_train.txt')
data.train.activity <- read.csv('C:/Users/kmw793/Desktop/DataScience/UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
data.train.subject <- read.csv('C:/Users/kmw793/Desktop/DataScience/UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')
names(data.train) <- c(c('subject', 'activity'), features)

data.test.x <- read.table('C:/Users/kmw793/Desktop/DataScience/UCI HAR Dataset/test/X_test.txt')
data.test.activity <- read.csv('C:/Users/kmw793/Desktop/DataScience/UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
data.test.subject <- read.csv('C:/Users/kmw793/Desktop/DataScience/UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')


data.train <-  data.frame(data.train.subject, data.train.activity, data.train.x)
data.test <-  data.frame(data.test.subject, data.test.activity, data.test.x)
names(data.test) <- c(c('subject', 'activity'), features)

### merge

data.all <- rbind(data.train, data.test)

### select mean and std. dev. 

col.select <- grep('mean|std', features)
data.sub <- data.all[,c(1,2,col.select + 2)]

### descriptive activity labels

activity.labels <- read.table('C:/Users/kmw793/Desktop/DataScience/UCI HAR Dataset/activity_labels.txt', header = FALSE)
activity.labels <- as.character(activity.labels[,2])
data.sub$activity <- activity.labels[data.sub$activity]

### descriptive variable names

name.new <- names(data.sub)
name.new <- gsub("[(][)]", "", name.new)
name.new <- gsub("^t", "TimeDomain_", name.new)
name.new <- gsub("^f", "FrequencyDomain_", name.new)
name.new <- gsub("Acc", "Accelerometer", name.new)
name.new <- gsub("Gyro", "Gyroscope", name.new)
name.new <- gsub("Mag", "Magnitude", name.new)
name.new <- gsub("-mean-", "_Mean_", name.new)
name.new <- gsub("-std-", "_StandardDeviation_", name.new)
name.new <- gsub("-", "_", name.new)
names(data.sub) <- name.new


### independent tidy data set
data.tidy <- aggregate(data.sub[,3:81], by = list(activity = data.sub$activity, subject = data.sub$subject),FUN = mean)
write.table(x = data.tidy, file = "data_tidy.txt", row.names = FALSE)

