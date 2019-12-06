##Path for project data
path_project <- "./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/"

##Store all file names in one list
data_list <- list.files(path_project, recursive = TRUE)

##Read test table
x_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", header = FALSE)

##Read train table
x_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/x_train.txt", header = FALSE)
y_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", header = FALSE)

##Read feature table
features <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt", header = FALSE)

##Read activity labels
act_labels <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", header = FALSE)

##Tagging test and train data
colnames(x_test) <- features[, 2]
colnames(y_test) <- "activity_ID"
colnames(subject_test) <- "subject_ID"
colnames(x_train) <- features[, 2]
colnames(y_train) <- "activity_ID"
colnames(subject_train) <- "subject_ID"
colnames(act_labels) <- c("activity_ID", "activity_Type")

##Merging test and train data
test_group <- cbind(x_test, y_test, subject_test)
train_group <- cbind(x_train, y_train, subject_train)

##Merging main data
dataset_complete <- rbind(test_group, train_group)

##Extracting mean and standard deviation data
col_names <- colnames(dataset_complete)
position_vector <- c(grepl("activity_ID", col_names) | grepl("subject_ID", col_names) | grepl("mean..", col_names) | grepl("std..", col_names))
dataset_extract <- dataset_complete[ , position_vector == TRUE]

##Inserting activity label
dataset_activity_names <- merge(dataset_extract, act_labels, by = "activity_ID", all.x = TRUE)

##Creating dataset with average of each variable for each activity and each subject
ave_dataset_activity_names <- aggregate(. ~subject_ID + activity_ID, dataset_activity_names, mean)
ave_dataset_activity_names <- ave_dataset_activity_names[order(ave_dataset_activity_names$subject_ID, ave_dataset_activity_names$activity_ID),]

##Write final data table
write.table(ave_dataset_activity_names, "ave_dataset_activity_names.txt", row.names = FALSE)

