library(dplyr)

features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

X <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)

colnames(X) <- features$V2
colnames(y) <- "Activity"
colnames(subject) <- "Subject"

data <- cbind(subject, y, X)

data_mean_std <- data %>%
  select(Subject, Activity, contains("mean"), contains("std"))

data_mean_std$Activity <- factor(data_mean_std$Activity,
                                 levels = activity_labels$V1,
                                 labels = activity_labels$V2)

names(data_mean_std) <- gsub("\\(\\)", "", names(data_mean_std))
names(data_mean_std) <- gsub("-", "_", names(data_mean_std))
names(data_mean_std) <- gsub("^t", "Time_", names(data_mean_std))
names(data_mean_std) <- gsub("^f", "Freq_", names(data_mean_std))

tidy_data <- data_mean_std %>%
  group_by(Subject, Activity) %>%
  summarise_all(mean)

write.table(tidy_data, "tidy_data.txt", row.names = FALSE)