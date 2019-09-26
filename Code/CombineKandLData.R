#####The purpose of this script is to pull in the processed driving data for the various stations around Baker Creek, NWT, plot the various variables, adjust the variables, and combine the data into 1 continuous set

#####Load Libraries
library(tidyverse)
library(dplyr)
library(lubridate)

#####Load the individual driving data files
setwd("C:/Users/haley/OneDrive/Documents/1.MWS2018-2019/T2/Project/ECCC_Project/R Code/")
load("./Vital.Rda")
load("./Landing.Rda")
load("./GEM_data.Rda")

GEM_data <- filter(GEM_data, year(DateTime)>= 2005) #Filter down GEM data since longer period

# p <- period(6, units="day")
# VitalShift09 <- mutate(Vital, DateTime=if_else(year(DateTime)==2009,DateTime-p,DateTime))

##### Remove Vital data in 2009 from June 21 to the end of the year for Kin and Lin, and 2016 before (and including) April 16 for the Kin data
VitalKin <- filter(Vital, !(date(DateTime)>= "2008-06-20" & date(DateTime)<= "2008-12-31"))
VitalKin <- filter(VitalKin, !(date(DateTime)>="2016-04-01"&date(DateTime)<"2016-04-16"))
#####Shift the 2009 Vital data back by 3 days to match the Yellowknife and GEM Temperature data
p <- period(3, units="day")
VitalKin <- mutate(VitalKin, DateTime=if_else(year(DateTime)==2009,DateTime-p,DateTime))

VitalLin <- filter(Vital, !(date(DateTime)>= "2008-06-20" & date(DateTime)<= "2008-12-31"))
VitalLin <- mutate(VitalLin, DateTime=if_else(year(DateTime)==2009,DateTime-p,DateTime))

#####Combine all the data
##Use this first section to choose whether or not to use the shifted, filtered, or original version of the Vital data

DrivingShift <- rbind(VitalShift09, Landing, GEM_data)

DrivingOrig <- rbind(Vital, Landing, GEM_data)

DrivingKin <- rbind(VitalKin, Landing, GEM_data)

DrivingLin <- rbind(VitalLin, Landing, GEM_data)

##### Explore the Kin (incoming shortwave radiation) data
Kin1 <- select(DrivingKin, DateTime, Station, Kin)
Kin <- Kin1
Kin <- Kin %>% 
  filter(!Station %in% c("GEMLanding", "GEMYellowknifeA", "YellowknifeA")) %>%
  mutate(Date=date(DateTime)) #%>%
  # group_by(Date, Station) %>%
  # summarise(DayAvgK=mean(Kin))

Kin$CommonDate <- as.Date(paste0("2001-", format(Kin$Date, "%j")),"%Y-%j")

#Plot and compare the data
Kin_05_11 <- filter(Kin, year(Date)>=2005 & year(Date)<=2011)
ggplot() +
  geom_line(data=Kin_05_11, mapping=aes(x=CommonDate, y=DayAvgK, color=Station), size=0.5) +
  facet_grid(year(Kin_05_11$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Incoming Shortwave - 2005-2011(filtered,shifted)")

Kin_12_18 <- filter(Kin, year(Date)>=2012)
ggplot() +
  geom_line(data=Kin_12_18, mapping=aes(x=CommonDate, y=DayAvgK, color=Station), size=0.5) +
  facet_grid(year(Kin_12_18$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Incoming Shortwave - 2012-2018(filtered)")
# 
# Kin08Inspect <- filter(Kin, DateTime>="2008-06-20 00:00:00")
# Kin08Inspect <- spread(Kin08Inspect, key="Station", value="Kin")
# Kin08Inspect <- mutate(Kin08Inspect, Diff=GEMVital-Vital)


##### Explore the Lin (incoming longwave radiation) data
Lin1 <- select(DrivingLin, DateTime, Station, Lin)
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

setwd("C:/Users/haley/OneDrive/Documents/1.MWS2018-2019/T2/Project/ECCC_Project/R Code/")
KFinal <- select(KinComb, DateTime, Combined)
KWrite <- select(KinComb, Combined)
write_excel_csv(KFinal, "../MESH Model/Baker Creek Model Files/basin_shortwave.xlsx.csv")
write_tsv(KWrite, "../MESH Model/Baker Creek Model Files/basin_shortwave.csv", col_names=FALSE)

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

setwd("C:/Users/haley/OneDrive/Documents/1.MWS2018-2019/T2/Project/ECCC_Project/R Code/")
LFinal <- select(LinComb, DateTime, Combined)
LWrite <- select(LinComb, Combined)
write_excel_csv(LFinal, "../MESH Model/Baker Creek Model Files/basin_longwave.xlsx.csv")
write_tsv(LWrite, "../MESH Model/Baker Creek Model Files/basin_longwave.csv", col_names=FALSE)

