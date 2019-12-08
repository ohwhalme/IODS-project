#Otto Halmesvaara
#Data Wrangling for Ex6
#Data source: https://github.com/KimmoVehkalahti/MABS [See Vehkalahti and Everitt (2018).]

#Loading the data files (wide format) and inspecting data structure
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header = TRUE, sep = " ")
BPRS <- as.data.frame(BPRS)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep ="\t")
RATS <- as.data.frame(RATS)
str(BPRS)
View(BPRS)
str(RATS)
View(RATS)

#There are 40 observations and 11 variables in the "BPRS" data set. "treatment" variable consist of two types of treatments, which ability to reduce psychiatric sympots was tested. "Subject" variable refers to subject number (20 subject in each treatment group). "week0" to "week8" refers to each participants score on BPRS (brief psychiatric rating scale) on that particular week of the trial. 
#There are 16 observations and 13 variables in the "RATS" data set. "ID" refers to participant (rat in this case) number, "Group" to different dietary group the rats were assigned to, and WD1 to WD64 to each rats weight in grams on that particular time point in the trial (9 week time period).

#Converting categorical variables to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

#Converting data sets to long form and adding "week" variable to BPRS and "time" to RATS
library(dplyr)
library(tidyr)
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks, 5, 5)))
RATSL <- RATS %>% gather(key = WD, value = Weight, -ID, -Group) %>% mutate(Time = as.integer(substr(WD, 3, 4)))

#Comparing wide and long forms of the data sets
str(BPRSL)
View(BPRSL)
str(RATSL)
View(RATSL)

#Now there are 360 obervations and 5 variables in the BPRS(L) data. This reflects the fact that "week0" to "week8" variables were converted into "week" and "weeks" variable (both giving essentially the same information) and each respondents score on the bprs was recoded into a separate "bprs" variable. As can be seen from the "subject" variable, participant scores from both treatment groups have been stacked on top of each other nine times (20 + 20 * 9 = 360) so the data does not take into account anymore that the 9 different measurement points comes from the same 40 participants.
#Same can be seen with the "RATS(L) data. Formerly, there were 16 observations and 13 variables, and now there are 176 observations and 5 variables. Again, the repeated measures element of the data have been "dissolved" (although, we can infer the original data structure when we look at the pariticipant "ID"). "WD1" to 64 have been transformed into "Time" and "WD" variables, and separate "Weight" variable have been created. The same 16 participant are repeated 11 times in the data set (corresponding to the number of measurement points in the wide form) giving us 16 * 11 = 176 observations.

#Saving the data sets
write.csv(BPRS, file = "C:/Users/OHW/Desktop/R/IODS-project/data/BPRS.csv")
write.csv(BPRSL, file = "C:/Users/OHW/Desktop/R/IODS-project/data/BPRSL.csv")
write.csv(RATS, file = "C:/Users/OHW/Desktop/R/IODS-project/data/RATS.csv")
write.csv(RATSL, file = "C:/Users/OHW/Desktop/R/IODS-project/data/RATSL.csv")