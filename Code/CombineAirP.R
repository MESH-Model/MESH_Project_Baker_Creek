#####The purpose of this script is to pull in the processed driving data for the various stations around Baker Creek, NWT, plot the various variables, adjust the variables, and combine the data into 1 continuous set

#####Load Libraries
library(tidyverse)
library(dplyr)
library(lubridate)

#####Load the individual driving data files
setwd("C:/Users/haley/OneDrive/Documents/1.MWS2018-2019/T2/Project/ECCC_Project/R Code/")
load("./Vital.Rda")
load("./Landing.Rda")
load("./Yknife_HalfHr.Rda")
load("./GEM_data.Rda")

GEM_data <- filter(GEM_data, year(DateTime)>= 2005) #Filter down GEM data since longer period

#####Shift the 2009 Vital data back by 6 days to match the Yellowknife and GEM data
p <- period(6, units="day")
VitalShift09 <- mutate(Vital, DateTime=if_else(year(DateTime)==2009,DateTime-p,DateTime))

#####Combine all the data
##Use this first section to choose whether or not to use the shifted version of the Vital data, or the original

DrivingShift <- rbind(VitalShift09, Landing, Yknife, GEM_data)
DrivingOrig <- rbind(Vital, Landing, Yknife, GEM_data)

##### Explore the Air Pressure data
P1 <- select(DrivingShift, DateTime, Station, AirP_Pa)
P <- P1
P <- P %>%
  filter(!Station %in% c("GEMLanding", "GEMYellowknifeA", "Landing")) %>%
  mutate(Date=date(DateTime))
  # group_by(Date, Station) %>%
  # summarise(DailyAvgP=mean(AirP_Pa))

#Plot and compare the data 
P$CommonDate <- as.Date(paste0("2000-", format(P$Date, "%j")),"%Y-%j")

P_05_11 <- filter(P, year(Date)>=2005 & year(Date)<=2011)
ggplot() +
  geom_line(data=P_05_11, mapping=aes(x=CommonDate, y=DailyAvgP, color=Station), size=0.5) +
  facet_grid(year(P_05_11$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Daily Average Air Pressure - 2005-2011(shift6)")

P_12_18 <- filter(P, year(Date)>=2012 & year(Date)<=2018)
ggplot() +
  geom_line(data=P_12_18, mapping=aes(x=CommonDate, y=DailyAvgP, color=Station), size=0.5) +
  facet_grid(year(P_12_18$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Daily Average Air Pressure - 2012-2018")

P_09 <- P %>% filter(year(Date)==2009)
ggplot() +
  geom_line(data=P_09, mapping=aes(x=CommonDate, y=DailyAvgP, color=Station), size=0.5) +
  facet_grid(year(P_09$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Daily Average Air Pressure - 2009(shift6)")

#####  Combine the AirP dataset and write to file
###In order to combine, need the columns to be DateTime, Station1, Station2, etc.; make sure you haven't calculated Daily average values above (comment out the "group_by" and "summarise" lines above)
PGEMVital <- filter(P, Station=="GEMVital")
PGEMVital <- PGEMVital %>%
  rename(GEMVital=AirP_Pa) %>%
  select(DateTime, GEMVital)

PVital <- filter(P, Station=="Vital")
PVital <- PVital %>% 
  rename(Vital=AirP_Pa) %>%
  select(DateTime, Vital)

PComb <- PGEMVital
PComb <- merge(PComb, PVital, by="DateTime", all=TRUE)
PComb$Combined <- NA
PComb <- filter(PComb, is.na(DateTime)==FALSE)

PComb$Combined[is.na(PComb$Combined)] <- paste0(PComb$Vital[is.na(PComb$Combined)])
PComb$Combined <- as.double(PComb$Combined)
PComb$Combined[is.na(PComb$Combined)] <- paste0(PComb$GEMVital[is.na(PComb$Combined)])
PComb$Combined <- as.double(PComb$Combined)

#Plot and check the combination
Check <- gather(PComb, GEMVital, Vital, Combined, key="Location", value="AirP_Pa")
Check <- Check %>%
  as_tibble %>%
  mutate(Date=date(DateTime)) %>%
  group_by(Date, Location) %>%
  summarise(DayAvgP=mean(AirP_Pa))
Check$LineSize <- rep(0.5, nrow(Check))
Check$LineSize[Check$Location=="Combined"]<- 1.0

Check$CommonDate <- as.Date(paste0("2001-", format(Check$Date, "%j")),"%Y-%j")

P_09 <- filter(Check, year(Date)==2009)
ggplot(data=P_09, mapping=aes(x=CommonDate, y=DayAvgP, color=Location, size=LineSize)) +
  geom_line() +
  scale_size(range=c(0.5,1.0), guide="none") +
  facet_grid(year(P_09$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Air Pressure - 2009")

setwd("C:/Users/haley/OneDrive/Documents/1.MWS2018-2019/T2/Project/ECCC_Project/R Code/")
PFinal <- select(PComb, DateTime, Combined)
PWrite <- select(PComb, Combined)
write_excel_csv(PFinal, "../MESH Model/Baker Creek Model Files/basin_pres.xlsx.csv")
write_tsv(PWrite, "../MESH Model/Baker Creek Model Files/basin_pres.csv", col_names=FALSE)