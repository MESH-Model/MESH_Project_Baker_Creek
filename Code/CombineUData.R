#####The purpose of this script is to pull in the processed driving data for the various stations around Baker Creek, NWT, plot the various variables, adjust the variables, and combine the data into 1 continuous set

#####Load Libraries
library(tidyverse)
library(dplyr)
library(lubridate)

#####Load the individual driving data files
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
u1 <- select(DrivingShift, DateTime, Station, u_4.4m, u_10m, u_40m)

#---OR---
# DrivingOrig <- rbind(Vital, Landing, Yknife, GEM_data)
# u1 <- select(DrivingOrig, DateTime, Station, u_4.4m, u_10m, u_40m)

##### Explore the Wind data
u <- u1
u <- u %>% 
  gather(u_4.4m, u_10m, u_40m, key="Height", value="Wind")%>%
  arrange(DateTime) %>%
  filter(is.na(Wind)==FALSE)
u$Height <- str_sub(u$Height, start=3)
u <- u %>% 
  filter(!Station %in% c("GEMLanding", "GEMYellowknifeA", "Landing")) %>%
  unite(Station, Height, col="Station", sep="_") %>%
  mutate(Date=date(DateTime))

##### Scale wind at Vital station (zm=4.4m) and YellowknifeA (10m) up to 40m height using equations 3.27 and 3.30a from Dingman
      ### u_star=k*u(zm)/ln((zm-zd)/z0) where k=0.4, zd=0.7*zveg, z0=0.1*zveg
      ### u(z) = 1/k*u_star*ln((z-zd)/z0)
zveg <- 2
zd <- 0.7*zveg
z0 <- 0.1*zveg

u <- u %>%
  mutate(u_star=if_else(grepl("Vital_4.4m",u$Station),0.4*Wind/log((4.4-zd)/z0),if_else(grepl("GEMVital_10m",u$Station),0.4*Wind/log((10-zd)/z0),if_else(grepl("YellowknifeA_10m",u$Station),0.4*Wind/log((10-zd)/z0),9999)))) %>%
  mutate(u_40m=if_else(grepl("Vital_4.4m",u$Station),1/0.4*u_star*log((40-zd)/z0),if_else(grepl("GEMVital_10m",u$Station),1/0.4*u_star*log((40-zd)/z0),if_else(grepl("YellowknifeA_10m",u$Station),1/0.4*u_star*log((40-zd)/z0),Wind)))) 

# u <- u %>%
#   group_by(Date, Station) %>%
#   summarise(DailyAvgu=mean(u_40m))

# u$CommonDate <- as.Date(paste0("2001-", format(u$Date, "%j")),"%Y-%j")
# 
# u_05_11 <- filter(u, year(Date)>=2005 & year(Date)<=2011)
# ggplot() +
#   geom_line(data=u_05_11, mapping=aes(x=CommonDate, y=DailyAvgu, color=Station), size=0.5) +
#   facet_grid(year(u_05_11$Date) ~ .) +
#   scale_x_date(labels=function(x) format(x,"%d-%b")) +
#   labs(title="Daily Average Wind Speed - 2005-2011(scaled)")
# 
# u_12_18 <- filter(u, year(Date)>=2012 & year(Date)<=2018)
# ggplot() +
#   geom_line(data=u_12_18, mapping=aes(x=CommonDate, y=DailyAvgu, color=Station), size=0.5) +
#   facet_grid(year(u_12_18$Date) ~ .) +
#   scale_x_date(labels=function(x) format(x,"%d-%b")) +
#   labs(title="Daily Average Wind Speed - 2012-2018(scaled)")
#  
# u_09 <- filter(u, year(Date)==2009)
# ggplot() +
#   geom_line(data=u_09, mapping=aes(x=DateTime, y=u_40m, color=Station), size=0.5) +
#   facet_grid(year(u_09$Date) ~ .) +
#   # scale_x_date(labels=function(x) format(x,"%d-%b")) +
#   labs(title="Daily Average Wind Speed - 2009(scaled)")

#####  Combine the Lin dataset and write to file
###In order to combine, need the columns to be DateTime, Station1, Station2, etc.; make sure you haven't calculated Daily average values above (comment out the "group_by" and "summarise" lines above)

uVital <- filter(u, Station=="Vital_4.4m")
uVital <- uVital %>%
  rename(Vital=u_40m) %>%
  select(DateTime, Vital)

uGEMVital <- filter(u, Station=="GEMVital_40m")
uGEMVital <- uGEMVital %>%
  rename(GEMVital=u_40m) %>%
  select(DateTime, GEMVital)

uComb <- uGEMVital
uComb <- merge(uComb, uVital, by="DateTime", all=TRUE)
uComb$Combined <- NA
uComb <- filter(uComb, is.na(DateTime)==FALSE)

uComb$Combined[is.na(uComb$Combined)] <- paste0(uComb$Vital[is.na(uComb$Combined)])
uComb$Combined <- as.double(uComb$Combined)
uComb$Combined[is.na(uComb$Combined)] <- paste0(uComb$GEMVital[is.na(uComb$Combined)])
uComb$Combined <- as.double(uComb$Combined)
uComb <- uComb %>% filter(year(DateTime)>=2005)
# Scaled Vital 4.4m observation matches reasonably well with GEM data, wheras Yellowknife data seems low. It is noted there are quite a few "zero" values in the hourly data, so Yellowknife data not included.

# Check for gaps and duplicates in the final datasets

library(CRHMr)
u_gaps <- uComb %>%
  select(DateTime, Combined)%>%
  rename(datetime=DateTime)
findGaps(u_gaps)

u_dups <- uComb%>%
  rename(datetime=DateTime)
findDupes(u_dups)
u_dups <- deDupe(u_dups)
if (is.character(u_dups)){
  uComb <- uComb
}else{
  uComb <- u_dups %>%
    rename(DateTime=datetime)
}

#Plot and check the combination
Check <- gather(uComb, GEMVital, Vital, Combined, key="Location", value="u_40m")
Check <- Check %>%
  as_tibble %>%
  mutate(Date=date(DateTime)) %>%
  group_by(Date, Location) %>%
  summarise(DayAvgu=mean(u_40m))
Check$LineSize <- rep(0.5, nrow(Check))
Check$LineSize[Check$Location=="Combined"]<- 1.0

Check$CommonDate <- as.Date(paste0("2001-", format(Check$Date, "%j")),"%Y-%j")

u_0511 <- filter(Check, year(Date) %in% 2005:2011)
ggplot(data=u_0511, mapping=aes(x=CommonDate, y=DayAvgu, color=Location, size=LineSize)) +
  geom_line() +
  scale_size(range=c(0.5,1.0), guide="none") +
  facet_grid(year(u_0511$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Wind Speed Check - 2005-2011")

u_1218 <- filter(Check, year(Date) %in% 2012:2018)
ggplot(data=u_1218, mapping=aes(x=CommonDate, y=DayAvgu, color=Location, size=LineSize)) +
  geom_line() +
  scale_size(range=c(0.5,1.0), guide="none") +
  facet_grid(year(u_1218$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Wind Speed Check - 2012-2018")

uFinal <- select(uComb, DateTime, Combined)
uWrite <- select(uComb, Combined)
uWrite6GRU <- uWrite %>%
  mutate(GRU2=Combined, GRU3=Combined, GRU4=Combined, GRU5=Combined, GRU6=Combined)
write_excel_csv(uFinal, "../Data/Processed/Driving/basin_wind.xlsx.csv")
write_tsv(uWrite, "../Data/Processed/Driving/Scenario1/basin_wind.csv", col_names=FALSE)
write_excel_csv(uWrite6GRU, "../Data/Processed/Driving/Scenario2and3/basin_wind.csv", col_names=FALSE) #Includes 6 columns with the "Combined" data - 1 per GRU
