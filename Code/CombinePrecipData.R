#####The purpose of this script is to pull in the processed driving data for the various stations around Baker Creek, NWT, plot the various variables, adjust the variables, and combine the data into 1 continuous set

#####Load Libraries
library(tidyverse)
library(dplyr)
library(lubridate)
library(colorspace)
library(CRHMr)

#####Load the individual driving data files
load("./Vital.Rda")
load("./Capa30min.Rda")
#load("./Yknife_precip.Rda") Didn't include Yellowknife precip for this version; originally included for comparison during the Capstone project

#####Shift the 2009 Vital data back by 6 days to match the Yellowknife and GEM data
# p <- period(6, units="day")
# VitalShift09 <- mutate(Vital, DateTime=if_else(year(DateTime)==2009,DateTime-p,DateTime))

### Explore the data

CAPADaily <- Capa30min %>%
  mutate(Date=date(DateTime)) %>%
  gather(CAPAYellowknifeA, CAPALanding, CAPAVital, key="Station", value="Precip_rate")%>%
  mutate(Amount=Precip_rate*3600*0.5) %>%
  group_by(Date, Station) %>%
  summarise(DailyPrecip=sum(Amount)) %>%
  ungroup()

p <- period(6, units="day")

VitalPrecip <- Vital %>%
  select(DateTime, Station, Rain_mm)%>%
  mutate(Precip_rate=Rain_mm/30/60)%>%
  select(-Rain_mm)%>%
  mutate(DateTime=if_else(year(DateTime)==2009,DateTime-p,DateTime)) %>% # Shift 2009 back 6 days
  mutate(Precip_rate=if_else(year(DateTime)==2008,9999,Precip_rate)) # Remove 2008 values (all zeroes)

VitalPrecip[VitalPrecip==9999] <- NA

VitalPrecipDaily <- VitalPrecip %>%
  mutate(Date=date(DateTime)) %>%
  mutate(Amount=Precip_rate*3600*0.5) %>%
  group_by(Date, Station) %>%
  summarise(DailyPrecip=sum(Amount)) %>%
  ungroup()

PlotPrecip <- rbind(CAPADaily, VitalPrecipDaily)
PlotPrecip <- filter(PlotPrecip, Station %in% c("Vital", "CAPAVital"))

PlotPrecip$CommonDate <- as.Date(paste0("2001-", format(PlotPrecip$Date, "%j")),"%Y-%j")

Precip_05_11 <- filter(PlotPrecip, year(Date) %in% 2005:2011)
ggplot() +
  geom_line(data=Precip_05_11, mapping=aes(x=CommonDate, y=DailyPrecip, color=Station), size=0.5) +
  facet_grid(year(Precip_05_11$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Daily Precip - 2005-2011 (shifted)")

ggplot() +
  geom_col(data=Precip_05_11, position="dodge", mapping=aes(x=CommonDate, y=DailyPrecip, color=Station), size=0.5) +
  facet_grid(year(Precip_05_11$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Daily Precip - 2005-2011 (shifted)")

Precip_12_18<- filter(PlotPrecip, year(Date) %in% 2012:2018)
ggplot() +
  geom_line(data=Precip_12_18, mapping=aes(x=CommonDate, y=DailyPrecip, color=Station), size=0.5) +
  facet_grid(year(Precip_12_18$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Daily Precip - 2012-2018")


#####  Combine the Precip dataset and write to file
###In order to combine, need the columns to be DateTime, Station1, Station2, etc.

CapaP <- Capa30min %>%
  filter(year(DateTime)>= 2005)%>%
  select(DateTime, CAPAVital)%>% #Filter down GEM data since longer period
  rename(CapaPrecipRate=CAPAVital)

VitalP <- VitalPrecip %>%
  rename(VitalPrecipRate=Precip_rate)%>%
  select(-Station)

VitalP_check <- VitalP%>%
  rename(datetime=DateTime)
findDupes(VitalP_check)
VitalP_check <- deDupe(VitalP_check)
if (is.character(VitalP_check)){
  VitalP <- VitalP
}else{
  VitalP <- VitalP_check %>%
    rename(DateTime=datetime)
}
findDupes(VitalP_check)
  

PrecipComb <- CapaP
PrecipComb <- merge(PrecipComb, VitalP, by="DateTime", all=TRUE)
PrecipComb$Combined <- NA

PrecipComb$Combined[is.na(PrecipComb$Combined)] <- paste0(PrecipComb$VitalPrecipRate[is.na(PrecipComb$Combined)])
PrecipComb$Combined <- as.double(PrecipComb$Combined)
PrecipComb$Combined[is.na(PrecipComb$Combined)] <- paste0(PrecipComb$CapaPrecipRate[is.na(PrecipComb$Combined)])
PrecipComb$Combined <- as.double(PrecipComb$Combined)

# Check for gaps and duplicates in the final datasets

Precip_gaps <- PrecipComb %>%
  rename(datetime=DateTime) %>%
  select(datetime, Combined)
findGaps(Precip_gaps)

Precip_dups <- PrecipComb%>%
  rename(datetime=DateTime) %>%
  select(datetime, Combined)
findDupes(Precip_dups)
Precip_dups <- deDupe(Precip_dups)
if (is.character(Precip_dups)){
  PrecipComb <- PrecipComb
}else{
  PrecipComb <- Precip_dups %>%
    rename(DateTime=datetime)
  PrecipComb$VitalPrecipRate <- as.double(PrecipComb$VitalPrecipRate)
}


# Plot combined and original to check
Check <- PrecipComb %>%
  rename(Capa=CapaPrecipRate, Vital=VitalPrecipRate)%>%
  gather(Capa, Vital, Combined, key="Station", value="PrecipRate")%>%
  mutate(Date=date(DateTime))%>%
  mutate(Amount=PrecipRate*3600*0.5)%>%
  group_by(Date, Station)%>%
  summarise(DailyPrecip=sum(Amount, na.rm=TRUE))%>%
  ungroup()

Check05 <- filter(Check, year(Date)==2005)

Check$CommonDate <- as.Date(paste0("2001-", format(Check$Date, "%j")),"%Y-%j")
Check <- mutate(Check, LineSize = if_else(Station == "Combined", 1, 0.5))

PrecipCheck0511 <- filter(Check, year(Date) %in% 2005:2011)
ggplot() +
  geom_line(data=PrecipCheck0511, mapping=aes(x=CommonDate, y=DailyPrecip, color=Station, group=Station, size=Station, alpha=Station)) +
  scale_size_manual(values=c(0.5, 2, 0.5))+
  scale_alpha_manual(values=c(1,0.2,1))+
  facet_grid(year(PrecipCheck0511$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Daily Precip - 2005-2011 (check)")

PrecipCheck1218 <- filter(Check, year(Date) %in% 2012:2018)
ggplot() +
  geom_line(data=PrecipCheck1218, mapping=aes(x=CommonDate, y=DailyPrecip, color=Station, group=Station, size=Station, alpha=Station)) +
  scale_size_manual(values=c(0.5, 2, 0.5))+
  scale_alpha_manual(values=c(1,0.2,1))+
  facet_grid(year(PrecipCheck1218$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Daily Precip - 2012-2018 (check)")

#Save PrecipComb data frame, and save the precipitation driving data .csv files

save(PrecipComb, file="./PrecipComb.Rda")

PrecipFinal <- select(PrecipComb, DateTime, Combined)
PrecipWrite <- select(PrecipComb, Combined)
PrecipWrite6GRU <- PrecipWrite %>%
  mutate(GRU2=Combined, GRU3=Combined, GRU4=Combined, GRU5=Combined, GRU6=Combined)
write_excel_csv(PrecipFinal, "../Data/Processed/Driving/basin_rain.xlsx.csv")
write_tsv(PrecipWrite, "../Data/Processed/Driving/Scenario1/basin_rain.csv", col_names=FALSE)
write_excel_csv(PrecipWrite6GRU, "../Data/Processed/Driving/Scenario2and3/basin_rain.csv", col_names=FALSE) #Includes 6 columns with the "Combined" data - 1 per GRU

##### Decide start date for the model (no recent rain events)
RecentRain <- filter(PrecipComb, year(DateTime)==2005 & month(DateTime) %in% c(09, 10))
RecentRain <- RecentRain %>%
  select(DateTime, Combined) %>%
  mutate(Amount=Combined*3600*0.5) %>%
  mutate(Date=date(DateTime)) %>%
  group_by(Date) %>%
  summarise(DailyPrecip=sum(Amount)) %>%
  ungroup()
  