#Otto Halmesvaara
#Data Wrangling for Ex5
#Data source: http://hdr.undp.org/en/content/human-development-index-hdi

#Downloading the data
human <- read.table("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt", header = TRUE, sep = ",")

#Inspecting structure and dimensions
str(human)
dim(human)

#195 observation (rows) and 19 variables (columns)

#Variable descriptions (taken from: https://raw.githubusercontent.com/TuomoNieminen/Helsinki-Open-Data-Science/master/datasets/human_meta.txt)

#"Country" = Country name
#"GNI" = Gross National Income per capita
#"Life.Exp" = Life expectancy at birth
#"Edu.Exp" = Expected years of schooling 
#"Mat.Mor" = Maternal mortality ratio
#"Ado.Birth" = Adolescent birth rate
#"Parli.F" = Percetange of female representatives in parliament
#"Edu2.F" = Proportion of females with at least secondary education
#"Edu2.M" = Proportion of males with at least secondary education
#"Labo.F" = Proportion of females in the labour force
#"Labo.M" " Proportion of males in the labour force
#"Edu2.FM" = Edu2.F / Edu2.M
#"Labo.FM" = Labo2.F / Labo2.M

#Mutating variable "GNI" to numeric
library(stringr)
library(dplyr)
human$GNI <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric

#Selecting variables "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F"
human <- select(human, one_of(c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")))

#Excluding missing cases
human <- filter(human, complete.cases(human) == TRUE)

#Removing observations which relate to regions instead of countries
human <- human[1:155, ]

#Defining row names of the data by the country names and removing the country name column from the data
rownames(human) <- human$Country
human <- human[ , 2:9]

#Saving the data
write.csv(human, file = "C:/Users/OHW/Desktop/R/IODS-project/data/human.csv")