library(reshape2)
library(dplyr)

datafolder <-'/home/okhaz/Downloads/UCI\ HAR\ Dataset/'


trainpath<-paste0(datafolder,'train/X_train.txt')
trainpathy<-paste0(datafolder,'train/y_train.txt')
testpathy<-paste0(datafolder,'test/y_test.txt')
testpath<-paste0(datafolder,'test/X_test.txt')
activitypath <- paste0(datafolder, 'activity_labels.txt')
featurespath<-paste0(datafolder,'features.txt')
subjecttest <- paste0(datafolder,'test/subject_test.txt')
subjecttrain <- paste0(datafolder,'train/subject_train.txt')



df <- read.table(trainpath)
df_test <- read.table(testpath)
df_y<-read.table(trainpathy)
df_test_y<-read.table(testpathy)
features <- read.table(featurespath)
activity_names <- read.table(activitypath)



df_all <- rbind(df, df_test)
df_y_all <- rbind(df_y, df_test_y)




ind<-grepl('(?i)(std|mean)',features$V2)

#subscript dataframe with a columns that contain mean or avg observations
df_meanavg <- df_all[,ind]
actual_features <- features$V2[ind]

#give descriptive column names to df
colnames(df_meanavg) <- actual_features


subject_test <- read.table(subjecttest)
subject_train <- read.table(subjecttrain)


df_final0<-cbind(df_meanavg, df_y_all)
subject_num <- rbind(subject_train,subject_test)
df_final0$subject_num<-as.integer(subject_num$V1)


by_act_subj <- group_by(df_final0,V1,subject_num)
df_final1   <-   by_act_subj %>% summarise_each("mean")

df_final2 <- merge(df_final1, activity_names, by.x = "V1",by.y="V1", all.x=TRUE, sort=FALSE)
df_final2$V1 <- NULL
df_final2<-df_final2[,c(1,88,2:87)]
colnames(df_final2)[2] <- "Activity name"
write.table(df_final2, file="TIDY_DATASET_UCI.txt",col.names = FALSE)
