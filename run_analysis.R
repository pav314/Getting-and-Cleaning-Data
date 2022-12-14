# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  
# 
# You should create one R script called run_analysis.R that does the following. 
# 
# 1. Merges the training and the test sets to create one data set.
# 
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 
# 3. Uses descriptive activity names to name the activities in the data set
# 
# 4. Appropriately labels the data set with descriptive variable names. 
# 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(downloader)
library(readr)
library(tidyverse)

options(scipen = 999)

# helper function to bind columns of different lengths and fill shorter column with filler NA's
bind_cols_fill <- function(x, y){
  if(nrow(x) != nrow(y))
  {
    if(nrow(x) < nrow(y))
    {
      while(nrow(x) != nrow(y))
      {
        x[nrow(x)+1,] <- NA
      }
    }
    if(nrow(y) < nrow(x))
    {
        while(nrow(x) != nrow(y))
      {
        y[nrow(y)+1,] <- NA
      }
    }
  }
  cbind(x, y)
}

# Changes strings in scientific notation into dbls
from_scientific_notation <- function(x)
{
  if(is.na(x))
  {
    return(NA)
  }
  parts <- str_split(x, "e", simplify = TRUE)
  c <- parts[1]
  c <- gsub("[^0-9.-]", "", c)
  e <- parts[2]
  c <- as.numeric(c)
  e <- as.numeric(e)
  #y <- b*10^p
  y <- c*10^e
  y
} 

# Creates List of strings in scientific notation
create_as_list <- function(x)
{
 my_list  <- strsplit(x, " +")
}

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# downloads and unzips dataset from given url
download(url, dest="dataset.zip", mode="wb") 
unzip ("dataset.zip", exdir = ".")


# import datasets
y_test <- read_csv("UCI HAR Dataset/test/y_test.txt", col_names = "y_test")
#View(y_test)

x_test <- read_csv("UCI HAR Dataset/test/x_test.txt", col_names = "x_test")
#View(x_test)
x_test %>% count %>% print
View(x_test)
#Looks like x_test is a list created by a string of scientific notation values.


subject_test <- read_csv("UCI HAR Dataset/test/subject_test.txt", col_names = "subject_test")
#View(subject_test)

subject_test %>% count %>% print

x_y_test <- bind_cols_fill(x_test, y_test)
test_df <- bind_cols_fill(x_y_test, subject_test)
#View(test_df)
#View(test_df)

y_train <- read_csv("UCI HAR Dataset/train/y_train.txt", col_names = "y_train")
#View(y_train)

x_train <- read_csv("UCI HAR Dataset/train/x_train.txt", col_names = "x_train")
#View(x_train)

subject_train <- read_csv("UCI HAR Dataset/train/subject_train.txt", col_names = "subject_train")
#View(subject_train)

x_y_train <- bind_cols_fill(x_train, y_train)
train_df <- bind_cols_fill(x_y_train, subject_train)

full_df <- bind_cols_fill(train_df, test_df)
glimpse(full_df)

#get all files from train Inertial Signals
setwd("~/Getting and Cleaning Data Wk 4/UCI HAR Dataset/train/Inertial Signals")
file_list <- list.files(path=".", pattern=NULL, all.files=FALSE,
                        full.names=FALSE)
#files from file_list ending in txt
file_list_txt <- list()
for(i in 1:length(file_list))
{
  if(str_detect(file_list[i], ".txt"))
     {
       file_list_txt <- c(file_list_txt, file_list[i])
     }
}
file_list_txt

for (i in 1:length(file_list_txt))
{
  name_string <- as.character(file_list_txt[i])
  name <-  sub("\\..*", "", name_string)
  temp <- read_csv(file_list_txt[i], col_names = name)
  full_df <- bind_cols_fill(temp, full_df)
}
row.names(full_df)
#glimpse(full_df)

#get all files from test Inertial Signals
setwd("~/Getting and Cleaning Data Wk 4/UCI HAR Dataset/test/Inertial Signals")
file_list <- list.files(path=".", pattern=NULL, all.files=FALSE,
                        full.names=FALSE)
#files from file_list ending in txt
file_list_txt <- list()
for(i in 1:length(file_list))
{
  if(str_detect(file_list[i], ".txt"))
  {
    file_list_txt <- c(file_list_txt, file_list[i])
  }
}
file_list_txt

for (i in 1:length(file_list_txt))
{
  name_string <- as.character(file_list_txt[i])
  name <-  sub("\\..*", "", name_string)
  temp <- read_csv(file_list_txt[i], col_names = name)
  full_df <- bind_cols_fill(temp, full_df)
}
row.names(full_df)
glimpse(full_df)

from_scientific_notation_v <- base::Vectorize(from_scientific_notation)

full_df_numeric <- full_df %>%
    mutate(x_test = from_scientific_notation_v(create_as_list(toString(full_df$x_test))),
           x_train = from_scientific_notation_v(create_as_list(toString(full_df$x_train))),
           body_acc_x_train = from_scientific_notation_v(create_as_list(toString(full_df$body_acc_x_train))),
           body_acc_y_train = from_scientific_notation_v(create_as_list(toString(full_df$body_acc_y_train))),
           body_acc_z_train = from_scientific_notation_v(create_as_list(toString(full_df$body_acc_z_train))),
           body_gyro_x_train = from_scientific_notation_v(create_as_list(toString(full_df$body_gyro_x_train))),
           body_gyro_y_train = from_scientific_notation_v(create_as_list(toString(full_df$body_gyro_y_train))),
           body_gyro_z_train = from_scientific_notation_v(create_as_list(toString(full_df$body_gyro_z_train))),
           total_acc_x_train = from_scientific_notation_v(create_as_list(toString(full_df$total_acc_x_train))),
           total_acc_y_train = from_scientific_notation_v(create_as_list(toString(full_df$total_acc_y_train))),
           total_acc_z_train = from_scientific_notation_v(create_as_list(toString(full_df$total_acc_z_train))),
           body_gyro_x_test = from_scientific_notation_v(create_as_list(toString(full_df$body_gyro_x_test))),
           body_gyro_y_test = from_scientific_notation_v(create_as_list(toString(full_df$body_gyro_y_test))),
           body_gyro_z_test = from_scientific_notation_v(create_as_list(toString(full_df$body_gyro_z_test))),
           total_acc_x_test = from_scientific_notation_v(create_as_list(toString(full_df$total_acc_x_test))),
           total_acc_y_test = from_scientific_notation_v(create_as_list(toString(full_df$total_acc_y_test))),
           total_acc_z_test = from_scientific_notation_v(create_as_list(toString(full_df$total_acc_z_test))),
           body_acc_x_test = from_scientific_notation_v(create_as_list(toString(full_df$body_acc_x_test))),
           body_acc_y_test = from_scientific_notation_v(create_as_list(toString(full_df$body_acc_y_test))),
           body_acc_z_test = from_scientific_notation_v(create_as_list(toString(full_df$body_acc_z_test)))
           )
glimpse(full_df_numeric)

means_and_sd <- full_df_numeric %>%
  summarise_all(list(mean = mean,
                sd = sd))

View(means_and_sd)

tidy_means <- full_df_numeric %>%
  summarise_all(list(mean = mean)) %>%
  pivot_longer(cols = everything()) %>%
  rename("variables" = "name") %>%
  rename("mean" = "value")

View(tidy_means)
