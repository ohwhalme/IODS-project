#Otto Halmesvaara, 15.11.2019, data wrangling exercise 3
#Data used: P. Cortez and A. Silva. Using Data Mining to Predict Secondary School Student Performance. In A. Brito and J. Teixeira Eds., Proceedings of 5th FUture BUsiness TEChnology Conference (FUBUTEC 2008) pp. 5-12, Porto, Portugal, April, 2008, EUROSIS, ISBN 978-9077381-39-7. 
#https://archive.ics.uci.edu/ml/datasets/Student+Performance

#Oppening the data files and creating data frames
student_mat <- read.csv("C:/Users/OHW/Desktop/R/IODS-project/data/student/student-mat.csv", sep = ";")
student_por <- read.csv("C:/Users/OHW/Desktop/R/IODS-project/data/student/student-por.csv", sep = ";")

#Examining structure and dimension of the two data frames
str(student_mat)
dim(student_mat)
str(student_por)
dim(student_por)

#student-mat data contains 395 observations (rows) and 33 variables (columns) and student-por data 649 observations (rows) and 33 variables (columns). Variable names seems to be identical between the data sets.

#Joining the two data frames (with identifier columns) and keeping only students who are present in both data frames
library(dplyr)
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
math_por <- inner_join(student_mat, student_por, by = join_by, suffix = c(".math", ".por"))

#Examining structure and dimensions of the new data frame
str(math_por)
dim(math_por)

#There are 382 observations and 53 variables in the new data frame

#Combining duplicate answers in the new data frame (using code from datacamp)

# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(student_mat)[!colnames(student_mat) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# glimpse at the new combined data
glimpse(alc)

#Averiging of the answers related to weekday and weekend alcohol consumption to create a new column 'alc_use' to the joined data. Then creating new logical column 'high_use' which is TRUE for students for which 'alc_use' is greater than 2 (and FALSE otherwise)
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)

#Inspecting the final data
glimpse(alc)

#Now there are 35 variables and 382 observations in the data frame

#Saving the final data
write.csv(alc, file = "C:/Users/OHW/Desktop/R/IODS-project/data/alc.csv")