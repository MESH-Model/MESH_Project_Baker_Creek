#####The purpose of this script is to pull in the processed driving data for the various stations around Baker Creek, NWT, plot the various variables, adjust the variables, and combine the data into 1 continuous set

#####Load Libraries
library(tidyverse)
library(dplyr)
library(lubridate)

#####Load the individual driving data files
load("./Vital.Rda")
load("./Landing.Rda")
load("./GEM_data.Rda")

GEM_data <- filter(GEM_data, year(DateTime)>= 2005) #Filter down GEM data since longer period

# p <- period(6, units="day") VitalShift09 <- mutate(Vital,
# DateTime=if_else(year(DateTime)==2009,DateTime-p,DateTime))

##### Remove Vital data in 2008 from June 21 to the end of the year for Kin and Lin, and 2016 before (and including) April 16 for the Kin data
VitalKin <- filter(Vital, !(date(DateTime)>= "2008-06-20" & date(DateTime)<= "2008-12-31"))
VitalKin <- filter(VitalKin, !(date(DateTime)>="2016-04-01"&date(DateTime)<"2016-04-16"))
#####Shift the 2009 Vital data back by 3 days to match the Yellowknife and GEM Temperature data
p <- period(3, units="day")
VitalKin <- mutate(VitalKin, DateTime=if_else(year(DateTime)==2009,DateTime-p,DateTime))

VitalLin <- filter(Vital, !(date(DateTime)>= "2008-06-20" & date(DateTime)<= "2008-12-31"))
VitalLin <- mutate(VitalLin, DateTime=if_else(year(DateTime)==2009,DateTime-p,DateTime))

#####Combine all the data
##Use this first section to choose whether or not to use the shifted, filtered, or original version of the Vital data

#DrivingShift <- rbind(VitalShift09, Landing, GEM_data)
#Kin1 <- select(DrivingShift, DateTime, Station, Kin)

#---OR---

# DrivingOrig <- rbind(Vital, Landing, GEM_data)
# Kin1 <- select(DrivingOrig, DateTime, Station, Kin)
# Lin1 <- select(DrivingOrig, DateTime, Station, Lin)

#---OR---

DrivingKin <- rbind(VitalKin, Landing, GEM_data)
Kin1 <- select(DrivingKin, DateTime, Station, Kin)

DrivingLin <- rbind(VitalLin, Landing, GEM_data)
Lin1 <- select(DrivingLin, DateTime, Station, Lin)

##### Explore the Kin (incoming shortwave radiation) data

Kin <- Kin1
Kin <- Kin %>% 
  filter(!Station %in% c("GEMLanding", "GEMYellowknifeA", "YellowknifeA")) %>%
  mutate(Date=date(DateTime)) #%>%
  # group_by(Date, Station) %>%
  # summarise(DayAvgK=mean(Kin))

Kin$CommonDate <- as.Date(paste0("2001-", format(Kin$Date, "%j")),"%Y-%j")

#Plot and compare the data
# Kin_05_11 <- filter(Kin, year(Date)>=2005 & year(Date)<=2011)
# ggplot() +
#   geom_line(data=Kin_05_11, mapping=aes(x=CommonDate, y=DayAvgK, color=Station), size=0.5) +
#   facet_grid(year(Kin_05_11$Date) ~ .) +
#   scale_x_date(labels=function(x) format(x,"%d-%b")) +
#   labs(title="Incoming Shortwave - 2005-2011(filtered,shifted)")
# 
# Kin_12_18 <- filter(Kin, year(Date)>=2012)
# ggplot() +
#   geom_line(data=Kin_12_18, mapping=aes(x=CommonDate, y=DayAvgK, color=Station), size=0.5) +
#   facet_grid(year(Kin_12_18$Date) ~ .) +
#   scale_x_date(labels=function(x) format(x,"%d-%b")) +
#   labs(title="Incoming Shortwave - 2012-2018(filtered)")
# 
# Kin08Inspect <- filter(Kin, DateTime>="2008-06-20 00:00:00")
# Kin08Inspect <- spread(Kin08Inspect, key="Station", value="Kin")
# Kin08Inspect <- mutate(Kin08Inspect, Diff=GEMVital-Vital)


##### Explore the Lin (incoming longwave radiation) data

Lin <- Lin1
Lin <- Lin %>% 
  filter(!Station %in% c("GEMLanding", "GEMYellowknifeA", "Landing", "YellowknifeA")) %>%
  mutate(Date=date(DateTime)) #%>%
# mutate(Year = year(DateTime), Month=month(DateTime), Day=day(DateTime), Time=paste(hour(DateTime),minute(DateTime),second(DateTime),sep=":"))
  # group_by(Date, Station) %>%
  # summarise(DayAvgL=mean(Lin))

Lin$CommonDate <- as.Date(paste0("2001-", format(Lin$Date, "%j")),"%Y-%j")

#Plot and compare the data
    # Only change the filter specs and the title, not the name of the var.; save as jpg for compare
    # Also change the "y" variable as necessary
Lin_plot <- filter(Lin, year(Date)<=2011)
Lin_plot <- Lin_plot %>%
  group_by(Date, Station) %>%
  summarise(DayAvgL=mean(Lin))
Lin_plot$CommonDate <- as.Date(paste0("2001-", format(Lin_plot$Date, "%j")),"%Y-%j")
ggplot() +
  geom_line(data=Lin_plot, mapping=aes(x=CommonDate, y=DayAvgL, color=Station), size=0.5) +
  facet_grid(year(Lin_plot$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Incoming Longwave - June-July 2008")

#####  Combine the Kin dataset and write to file
###In order to combine, need the columns to be DateTime, Station1, Station2, etc.; make sure you haven't calculated Daily average values above (comment out the "group_by" and "summarise" lines above)
KGEMVital <- filter(Kin, Station=="GEMVital")
KGEMVital <- KGEMVital %>%
  rename(GEMVital=Kin) %>%
  select(DateTime, GEMVital)

KVital <- filter(Kin, Station=="Vital")
KVital <- KVital %>% 
  rename(Vital=Kin) %>%
  select(DateTime, Vital)

KLanding <- filter(Kin, Station=="Landing")
KLanding <- KLanding %>% 
  rename(Landing=Kin) %>%
  select(DateTime, Landing)

KinComb <- KGEMVital
KinComb <- merge(KinComb, KVital, by="DateTime", all=TRUE)
KinComb <- merge(KinComb, KLanding, by="DateTime", all=TRUE)
KinComb$Combined <- NA
KinComb <- filter(KinComb, is.na(DateTime)==FALSE)

KinComb$Combined[is.na(KinComb$Combined)] <- paste0(KinComb$Vital[is.na(KinComb$Combined)])
KinComb$Combined <- as.double(KinComb$Combined)
KinComb$Combined[is.na(KinComb$Combined)] <- paste0(KinComb$Landing[is.na(KinComb$Combined)])
KinComb$Combined <- as.double(KinComb$Combined)
KinComb$Combined[is.na(KinComb$Combined)] <- paste0(KinComb$GEMVital[is.na(KinComb$Combined)])
KinComb$Combined <- as.double(KinComb$Combined)

KinComb <- mutate(KinComb, Combined=ifelse(Combined<=0,0,Combined))

# Check for gaps and duplicates in the final datasets

library(CRHMr)
KinComb_gaps <- KinComb %>%
  select(DateTime, Combined)%>%
  rename(datetime=DateTime)
findGaps(KinComb_gaps)

KinComb_dups <- KinComb%>%
  rename(datetime=DateTime)
findDupes(KinComb_dups)
KinComb_dups <- deDupe(KinComb_dups)
if (is.character(KinComb_dups)){
  KinComb <- KinComb
}else{
  KinComb <- KinComb_dups %>%
    rename(DateTime=datetime)
}

#Plot and check the combination
Check <- gather(KinComb, GEMVital, Vital, Landing, Combined, key="Location", value="Kin")
Check <- Check %>%
  as_tibble %>%
  mutate(Date=date(DateTime)) %>%
  group_by(Date, Location) %>%
  summarise(DayAvgK=mean(Kin))
Check$LineSize <- rep(0.5, nrow(Check))
Check$LineSize[Check$Location=="Combined"]<- 1.0

Check$CommonDate <- as.Date(paste0("2001-", format(Check$Date, "%j")),"%Y-%j")

Kin_05_11 <- filter(Check, year(Date)<=2011)
ggplot(data=Kin_05_11, mapping=aes(x=CommonDate, y=DayAvgK, color=Location, size=LineSize)) +
  geom_line() +
  scale_size(range=c(0.5,1.0), guide="none") +
  facet_grid(year(Kin_05_11$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Incoming Shortwave - 2005-2011(check)")

Kin_12_18 <- filter(Check, year(Date)>=2012)
ggplot(data=Kin_12_18, mapping=aes(x=CommonDate, y=DayAvgK, color=Location, size=LineSize)) +
  geom_line() +
  scale_size(range=c(0.5,1.0), guide="none") +
  facet_grid(year(Kin_12_18$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Incoming Shortwave - 2012-2018(check)")


KFinal <- select(KinComb, DateTime, Combined)
KWrite <- select(KinComb, Combined)
KWrite6GRU <- KWrite %>%
  mutate(GRU2=Combined, GRU3=Combined, GRU4=Combined, GRU5=Combined, GRU6=Combined)
write_excel_csv(KFinal, "../Data/Processed/Driving/basin_shortwave.xlsx.csv")
write_tsv(KWrite, "../Data/Processed/Driving/Scenario1/basin_shortwave.csv", col_names=FALSE)
write_excel_csv(KWrite6GRU, "../Data/Processed/Driving/Scenario2and3/basin_shortwave.csv", col_names=FALSE) #Includes 6 columns with the "Combined" data - 1 per GRU


#####  Combine the Lin dataset and write to file
###In order to combine, need the columns to be DateTime, Station1, Station2, etc.; make sure you haven't calculated Daily average values above (comment out the "group_by" and "summarise" lines above)
LGEMVital <- filter(Lin, Station=="GEMVital")
LGEMVital <- LGEMVital %>%
  rename(GEMVital=Lin) %>%
  select(DateTime, GEMVital)

LVital <- filter(Lin, Station=="Vital")
LVital <- LVital %>% 
  rename(Vital=Lin) %>%
  select(DateTime, Vital)

LinComb <- LGEMVital
LinComb <- merge(LinComb, LVital, by="DateTime", all=TRUE)
LinComb$Combined <- NA
LinComb <- filter(LinComb, is.na(DateTime)==FALSE)

LinComb$Combined[is.na(LinComb$Combined)] <- paste0(LinComb$Vital[is.na(LinComb$Combined)])
LinComb$Combined <- as.double(LinComb$Combined)
LinComb$Combined[is.na(LinComb$Combined)] <- paste0(LinComb$GEMVital[is.na(LinComb$Combined)])
LinComb$Combined <- as.double(LinComb$Combined)

# Check for gaps and duplicates in the final datasets

library(CRHMr)
LinComb_gaps <- LinComb %>%
  select(DateTime, Combined)%>%
  rename(datetime=DateTime)
findGaps(LinComb_gaps)

LinComb_dups <- LinComb%>%
  rename(datetime=DateTime)
findDupes(LinComb_dups)
LinComb_dups <- deDupe(LinComb_dups)
if (is.character(LinComb_dups)){
  LinComb <- LinComb
}else{
  LinComb <- LinComb_dups %>%
    rename(DateTime=datetime)
}

#Plot and check the combination
Check <- gather(LinComb, GEMVital, Vital, Combined, key="Location", value="Lin")
Check <- Check %>%
  as_tibble %>%
  mutate(Date=date(DateTime)) %>%
  group_by(Date, Location) %>%
  summarise(DayAvgL=mean(Lin))
Check$LineSize <- rep(0.5, nrow(Check))
Check$LineSize[Check$Location=="Combined"]<- 1.0

Check$CommonDate <- as.Date(paste0("2001-", format(Check$Date, "%j")),"%Y-%j")

Lin_05_11 <- filter(Check, year(Date)<=2011)
ggplot(data=Lin_05_11, mapping=aes(x=CommonDate, y=DayAvgL, color=Location, size=LineSize)) +
  geom_line() +
  scale_size(range=c(0.5,1.0), guide="none") +
  facet_grid(year(Lin_05_11$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Incoming Longwave - 2005-2011(check)")

Lin_12_18 <- filter(Check, year(Date)>=2012)
ggplot(data=Lin_12_18, mapping=aes(x=CommonDate, y=DayAvgL, color=Location, size=LineSize)) +
  geom_line() +
  scale_size(range=c(0.5,1.0), guide="none") +
  facet_grid(year(Lin_12_18$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Incoming Longwave - 2012-2018(check)")


#Write the .csv files for the model
LFinal <- select(LinComb, DateTime, Combined)
LWrite <- select(LinComb, Combined)
LWrite6GRU <- LWrite %>%
  mutate(GRU2=Combined, GRU3=Combined, GRU4=Combined, GRU5=Combined, GRU6=Combined)
write_excel_csv(LFinal, "../Data/Processed/Driving/basin_longwave.xlsx.csv")
write_tsv(LWrite, "../Data/Processed/Driving/Scenario1/basin_longwave.csv", col_names=FALSE)
write_excel_csv(LWrite6GRU, "../Data/Processed/Driving/Scenario2and3/basin_longwave.csv", col_names=FALSE) #Includes 6 columns with the "Combined" data - 1 per GRU
