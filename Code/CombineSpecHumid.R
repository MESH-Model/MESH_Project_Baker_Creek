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

##### Scale the specific humidity to 40m by converting RH to q using T40m rather than T2m for Vital and Yellowknife stations only (won't use Landing data in the final combined)
load(file="./TempScaledCombined.Rda")

VitalShiftq <- merge(VitalShift09, TComb, by="DateTime", all=TRUE)
VitalShiftq <- VitalShiftq %>%
  mutate(T_40m=Vital2.8) %>%
  select(-c("GEMVital", "YellowknifeA", "Vital2.8", "Vital4.4", "Combined")) %>%
  mutate(ea_40m=RH_2m/100*10^((0.7859+0.03477*T_40m)/(1.0+0.00412*T_40m)+2))%>%
  mutate(q_40m=0.622*ea_40m/(AirP_Pa-0.378*ea_40m)) %>%
  filter(is.na(DateTime)==FALSE, is.na(Station)==FALSE) %>%
  select(-ea_40m)

  ### Didn't make much difference, so use the observed q in the model

#####Combine all the data
##Use this first section to choose whether or not to use the shifted version of the Vital data, or the original

DrivingShift <- rbind(VitalShift09, Landing, Yknife, GEM_data)
DrivingOrig <- rbind(Vital, Landing, Yknife, GEM_data)
DrivingShiftq <- rbind(VitalShiftq, Landing, Yknife, GEM_data)

##### Explore the Specific Humidity data
q1 <- select(DrivingShift, DateTime, Station, q_1.1m, q_2m, q_4.4m, q_40m)
q <- q1
q <- q %>% gather(q_1.1m, q_2m, q_4.4m, q_40m, key="Height", value="q")%>%
  arrange(DateTime) %>%
  filter(is.na(q)==FALSE)
q$Height <- str_sub(q$Height, start=3)
q <- q %>%
  filter(!Station %in% c("GEMLanding", "GEMYellowknifeA", "Landing")) %>%
  unite(Station, Height, col="Station", sep="_") %>%
  mutate(Date=date(DateTime))

qplot <- q
qplot <- qplot %>%
  group_by(Date, Station) %>%
  summarise(DailyAvgq=mean(q))

#Plot and compare the data 
qplot$CommonDate <- as.Date(paste0("2000-", format(qplot$Date, "%j")),"%Y-%j")

q_05_11 <- filter(qplot, year(Date)>=2005 & year(Date)<=2011)
ggplot() +
  geom_line(data=q_05_11, mapping=aes(x=CommonDate, y=DailyAvgq, color=Station), size=0.5) +
  facet_grid(year(q_05_11$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Daily Average Specific Humidity - 2005-2011(shifted)")
# 
q_12_18 <- filter(qplot, year(Date)>=2012 & year(Date)<=2018)
ggplot() +
  geom_line(data=q_12_18, mapping=aes(x=CommonDate, y=DailyAvgq, color=Station), size=0.5) +
  facet_grid(year(q_12_18$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Daily Average Specific Humidity - 2012-2018(shifted)")
 
# Temp_2009 <- Temp1 %>% filter(year(Date)==2009)
# 
# ggplot() +
#   geom_line(data=Temp_2009, mapping=aes(x=CommonDate, y=DailyAvgT, color=Station), size=0.5) +
#   facet_grid(year(Temp_2009$Date) ~ .) + 
#   scale_x_date(labels=function(x) format(x,"%d-%b")) +
#   labs(title="Daily Average Temperature - 2009(shifted)")

#####  Combine the AirP dataset and write to file
###In order to combine, need the columns to be DateTime, Station1, Station2, etc.; make sure you haven't calculated Daily average values above (comment out the "group_by" and "summarise" lines above)
qVital <- filter(q, Station=="Vital_4.4m")
qVital <- qVital %>%
  rename(Vital=q) %>%
  select(DateTime, Vital)

qGEMVital <- filter(q, Station=="GEMVital_40m")
qGEMVital <- qGEMVital %>% 
  rename(GEMVital=q) %>%
  select(DateTime, GEMVital)

qComb <- qGEMVital
qComb <- merge(qComb, qVital, by="DateTime", all=TRUE)
qComb$Combined <- NA
qComb <- filter(qComb, is.na(DateTime)==FALSE)

qComb$Combined[is.na(qComb$Combined)] <- paste0(qComb$Vital[is.na(qComb$Combined)])
qComb$Combined <- as.double(qComb$Combined)
qComb$Combined[is.na(qComb$Combined)] <- paste0(qComb$GEMVital[is.na(qComb$Combined)])
qComb$Combined <- as.double(qComb$Combined)

#Plot and check the combination
Check <- gather(qComb, GEMVital, Vital, Combined, key="Location", value="q")
Check <- Check %>%
  as_tibble %>%
  mutate(Date=date(DateTime)) %>%
  group_by(Date, Location) %>%
  summarise(DayAvgq=mean(q))
Check$LineSize <- rep(0.5, nrow(Check))
Check$LineSize[Check$Location=="Combined"]<- 1.0

Check$CommonDate <- as.Date(paste0("2001-", format(Check$Date, "%j")),"%Y-%j")

q_05_11 <- filter(Check, year(Date) %in% 2005:2011)
ggplot(data=q_05_11, mapping=aes(x=CommonDate, y=DayAvgq, color=Location, size=LineSize)) +
  geom_line() +
  scale_size(range=c(0.5,1.0), guide="none") +
  facet_grid(year(q_05_11$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Specific Humidity - 2005-2011 (combined)")

setwd("C:/Users/haley/OneDrive/Documents/1.MWS2018-2019/T2/Project/ECCC_Project/R Code/")
qFinal <- select(qComb, DateTime, Combined)
qWrite <- select(qComb, Combined)
write_excel_csv(qFinal, "../MESH Model/Baker Creek Model Files/basin_humidity.xlsx.csv")
write_tsv(qWrite, "../MESH Model/Baker Creek Model Files/basin_humidity.csv", col_names=FALSE)