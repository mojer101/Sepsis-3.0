## TASK 1: SETUP
library(tidyverse)
library(data.table) ## For the fread function
library(lubridate)
library(tictoc)
source("sepsis_monitor_functions.R")



## TASK 2: SPEED READING
tic()
f <- makeSepsisDataset(read_fn = "fread", n = 50)
toc() #5 secs

tic()
f <- makeSepsisDataset(read_fn = "read_delim", n = 50)
toc() #18 secs



tic()
f <- makeSepsisDataset(read_fn = "fread", n = 100)
toc()#7.85 secs

tic()
f <- makeSepsisDataset(read_fn = "read_delim", n = 100)
toc()#34.45 secs


tic()
f <- makeSepsisDataset(read_fn = "fread", n = 500)
toc()#38.44 secs

tic()
f <- makeSepsisDataset(read_fn = "read_delim", n = 500)
toc()#171.59 secs



##TASK 3
library(googledrive)

df <- makeSepsisDataset()

# We have to write the file to disk first, then upload it
df %>% write_csv("sepsis_data_temp.csv")

# Uploading happens here
sepsis_file <- drive_put(media = "sepsis_data_temp.csv", 
                         path = "https://drive.google.com/drive/folders/1llc8-_x_GmDmX5ARsaRyR6lqzGRsKx3W",
                         name = "sepsis_data.csv")

# Set the file permissions so anyone can download this file.
sepsis_file %>% drive_share_anyone()



drive_deauth()
file_link <- "https://drive.google.com/file/d/1ytwf6dhjteIGFWJTza9bgWa_ariNzWn7/view?usp=share_link"

## All data up until now
new_data <- updateData(file_link)

## Include only most recent data
most_recent_data <- new_data %>%
  group_by(PatientID) %>%
  filter(obsTime == max(obsTime))

library(knitr)

dt <- most_recent_data %>%
  filter(SepsisLabel == 1) %>%
  arrange(desc(ICULOS)) %>%
  select(PatientID, ICULOS, HR, Temp, Resp) %>%
  rename("Hours in Hospital" = ICULOS,
         "Temperature" = Temp, 
         "Respiratory Rate" = Resp, 
         "Heart Rate" = HR) 

knitr::kable(dt, caption = paste("Data Updated on:", ymd_hms(now())))




  






