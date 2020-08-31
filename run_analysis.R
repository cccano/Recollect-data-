## download files
link <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

download.file(link,destfile = "./app.R/Dataset.zip")

## unzip data 
datos <- unzip("Dataset.zip", files = NULL, list = F)

## reading features and labels 
Activities <- read.table(datos[1], col.names = c("n","activity"))
features <- read.table(datos[2], col.names = c("n","functions"))

## read training data 

train_subj <- read.table(datos[26], col.names = "subject")
train_data <- read.table(datos[27], col.names = features$functions)
train_act <-  read.table(datos[28], col.names = "code")

## read test data

test_subj <- read.table(datos[14], col.names = "subject")
test_data <- read.table(datos[15], col.names = features$functions)
test_act <- read.table(datos[16], col.names = "code")


## merge training and test 

table_data <- rbind(train_data, test_data)
table_act <- rbind(train_act, test_act)
Subject <- rbind(train_subj, test_subj)
table_merge <- cbind(Subject, table_act, table_data)

## take mean and standard deviation 

library(dplyr)

dfsubset <- select(table_merge, subject, code, contains("mean"), contains("std"))
dfsubset$code <- Activities[dfsubset$code,2]


names(dfsubset) <- gsub("Freq", "", names(dfsubset))
names(dfsubset) <- gsub("BodyBody", "Body", names(dfsubset))
names(dfsubset) <- gsub("Acc", "Accelerometer", names(dfsubset))
names(dfsubset) <- gsub("^t", "Time", names(dfsubset))
names(dfsubset) <- gsub("Gyro", "Gyroscope", names(dfsubset))
names(dfsubset) <- gsub("Mag", "Magnitude", names(dfsubset))
names(dfsubset) <- gsub("^f", "Frequency", names(dfsubset))

dataset <- group_by(dfsubset, subject, activity)
summarize(dataset, funs(mean))

write.table(dataset, file = "./app.R/dataset.txt", row.names = FALSE)
