library(weathercan)
library(CRHMr)
library(tidyverse)

#Download the weather station data from the ECCC site; can specify dates from and to if you want
#Yellowknife has 2 different station names which cover the period from 1953 to present
y1706_hr <- weather_dl(station_id = 1706,interval="hour")
y1706_day <- weather_dl(station_id = 1706,interval="day")

y51058_hr <- weather_dl(station_id = 51058,interval="hour") 
y51058_day <- weather_dl(station_id = 51058,interval="day")

#Combine the hourly and daily data from the different station numbers into one
yknife_all_hr <- rbind(y1706_hr,y51058_hr)
yknife_all_day <- rbind(y1706_day,y51058_day)

#Change the yellowknife data to a data frame
yknife_all_hr <- as.data.frame(yknife_all_hr)
yknife_all_day <- as.data.frame(yknife_all_day)

#Reorder the columns so that the date and time column is first, and rename it to "datetime" for use with CRHMr
yknife_all_hr2 <- yknife_all_hr[,c(12,1,2,3,4,5,6,7,8,9,10,11,13:ncol(yknife_all_hr))]
yknife_all_hr2 <- rename(yknife_all_hr2, datetime=time)

#Save the weather data to a csv
setwd('C:/<your working directory here, if not already set where you want>')
write.csv(yknife_all_hr,file='./YellowknifeA_Hourly (no precip).csv')
write.csv(yknife_all_day,file='./YellowknifeA_Daily.csv')

#Save the Rda object to file for easy loading later
save(yknife_all_hr,file="yknife_all_hr.Rda")
save(yknife_all_day,file="yknife_all_day.Rda")
