#Otto Halmesvaara
#4.11.2019
#RStudio Exercise 2 DATA WRANGLING

#Creating data table for raw data
data_raw <- read.table("https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-data.txt", header = TRUE, sep = "\t")

#Inspecting dimensions and data structure
dim(data_raw)
str(data_raw)
#Raw data contains 183 rows and 60 columns. More precisely, columns 1 to 55 are one question items (scale 1-5) and columns 56, 57, 58, 59, and 60 are Age (years), Attitude (composite variable: Global attitude toward statistics), Points (total points concerning learning variables), and gender (male or female), respectively. For complete list of variables see https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS2-meta.txt.

#oppening packet dplyr
library(dplyr)

#Creating composite variables (sum/number of variables)
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30", "D06", "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

deep_columns <- select(data_raw, one_of(deep_questions))
data_raw$deep <- rowMeans(deep_columns)

surface_columns <- select(data_raw, one_of(surface_questions))
data_raw$surf <- rowMeans(surface_columns)

strategic_columns <- select(data_raw, one_of(strategic_questions))
data_raw$stra <- rowMeans(strategic_columns)

#Creating data set for the regression exercise, which includes "Age", "gender", "Points", and the aforomentioned composite variables
data <- select(data_raw, Age, gender, Points, Attitude, deep, surf, stra)

#Excluding observations where the exam points variable is zero
data <- filter(data, Points > 0)

#Data ready for Exercise 2
str(data)

#Cleaning up
rm(deep_columns, strategic_columns, surface_columns, deep_questions, strategic_questions, surface_questions, data_raw)

#Setting working directory
setwd("C:/Users/OHW/Desktop/R/IODS-project")

#Saving the data
write.csv(data, file = "C:/Users/OHW/Desktop/R/IODS-project/data/learning2014.csv")

#Checking the saved data
saved_data <- read.csv("C:/Users/OHW/Desktop/R/IODS-project/data/learning2014.csv")
saved_data = select(saved_data, -X)
str(saved_data)
head(saved_data)