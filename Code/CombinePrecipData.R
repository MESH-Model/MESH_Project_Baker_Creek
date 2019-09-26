#####The purpose of this script is to pull in the processed driving data for the various stations around Baker Creek, NWT, plot the various variables, adjust the variables, and combine the data into 1 continuous set

#####Load Libraries
library(tidyverse)
library(dplyr)
library(lubridate)
library(colorspace)

#####Load the individual driving data files
setwd("C:/Users/haley/OneDrive/Documents/1.MWS2018-2019/T2/Project/ECCC_Project/R Code/")
load("./Vital.Rda")
load("./CAPA_data_0.5hr.Rda")
load("./Yknife_precip.Rda")

CAPA_data_0.5hr <- filter(CAPA_data_0.5hr, year(DateTime)>= 2005) #Filter down GEM data since longer period

#####Shift the 2009 Vital data back by 6 days to match the Yellowknife and GEM data
p <- period(6, units="day")
VitalShift09 <- mutate(Vital, DateTime=if_else(year(DateTime)==2009,DateTime-p,DateTime))

#####Combine all the data
##First, calculate daily totals

CAPA <- CAPA_data_0.5hr

CAPADaily <- CAPA 
CAPADaily <- CAPADaily %>%
  mutate(Date=date(DateTime)) %>%
  mutate(Amount=Precip_rate*3600*0.5) %>%
  group_by(Date, Station) %>%
  summarise(DailyPrecip=sum(Amount)) %>%
  ungroup()

p <- period(6, units="day")
VitalPrecip <- select(Vital, DateTime, Station, Precip_rate)
VitalPrecip <- VitalPrecip %>%
  mutate(DateTime=if_else(year(DateTime)==2009,DateTime-p,DateTime)) %>%
  mutate(Precip_rate=if_else(year(DateTime)==2008,9999,Precip_rate))
VitalPrecip[VitalPrecip==9999] <- NA

VitalPrecipDaily <- VitalPrecip
VitalPrecipDaily <- VitalPrecipDaily %>%
  mutate(Date=date(DateTime)) %>%
  mutate(Amount=Precip_rate*3600*0.5) %>%
  group_by(Date, Station) %>%
  summarise(DailyPrecip=sum(Amount)) %>%
  ungroup()
  
YknifePrecipDaily <- select(Yknife_precip, DateTime, total_precip)
YknifePrecipDaily <- YknifePrecipDaily %>%
  filter(year(DateTime) %in% 2005:2018) %>%
  rename(DailyPrecip=total_precip) %>%
  mutate(Date=date(DateTime)) %>%
  select(-DateTime)
YknifePrecipDaily$Station <- "YellowknifeA"
YknifePrecipDaily <- YknifePrecipDaily[,c(2,3,1)] #reorder columns

PlotPrecip <- rbind(CAPADaily, VitalPrecipDaily, YknifePrecipDaily)
PlotPrecip <- filter(PlotPrecip, Station %in% c("Vital", "CAPAVital"))

PlotPrecip$CommonDate <- as.Date(paste0("2001-", format(PlotPrecip$Date, "%j")),"%Y-%j")

# Precip_05_11 <- filter(PlotPrecip, year(Date) %in% 2005:2011)
# ggplot() +
#   geom_col(data=Precip_05_11, position="dodge", mapping=aes(x=CommonDate, y=DailyPrecip, color=Station), size=0.5) +
#   facet_grid(year(Precip_05_11$Date) ~ .) +
#   scale_x_date(labels=function(x) format(x,"%d-%b")) +
#   labs(title="Daily Precip - 2005-2011 (shifted)")

# Precip_05_11<- filter(PlotPrecip, year(Date) %in% 2005:2011)
# ggplot() +
#   geom_line(data=Precip_05_11, mapping=aes(x=CommonDate, y=DailyPrecip, color=Station), size=0.5) +
#   facet_grid(year(Precip_05_11$Date) ~ .) +
#   scale_x_date(labels=function(x) format(x,"%d-%b")) +
#   labs(title="Daily Precip - 2005-2011 (shifted)")
# 
# Precip_12_18<- filter(PlotPrecip, year(Date) %in% 2012:2018)
# ggplot() +
#   geom_line(data=Precip_12_18, mapping=aes(x=CommonDate, y=DailyPrecip, color=Station), size=0.5) +
#   facet_grid(year(Precip_12_18$Date) ~ .) +
#   scale_x_date(labels=function(x) format(x,"%d-%b")) +
#   labs(title="Daily Precip - 2012-2018")

# ggplot() +
#   geom_line(data=Precip_05_11, mapping=aes(x=CommonDate, y=DailyPrecip, color=Station), size=0.5) +
#   facet_grid(year(Precip_05_11$Date) ~ .) +
#   scale_x_date(labels=function(x) format(x,"%d-%b")) +
#   labs(title="Daily Precip - 2005-2011 (shifted)")

PrecipSums <- PlotPrecip
PrecipSums <- PrecipSums %>%
  mutate(Year=year(Date)) %>%
  group_by(Year, Station) %>%
  summarise(AnnualPrecip = sum(DailyPrecip, na.rm=TRUE))

# ggplot()+
#   geom_col(data=PrecipSums, position="dodge", mapping=aes(x=Year, y=AnnualPrecip, fill=Station)) +
#   labs(title="Annual Precip")
# 


#####  Combine the Precip dataset and write to file
###In order to combine, need the columns to be DateTime, Station1, Station2, etc.; make sure you haven't calculated Daily average values above (comment out the "group_by" and "summarise" lines above)

DrivingPrecip <- rbind(CAPA, VitalPrecip)
DrivingPrecip <- arrange(DrivingPrecip, DateTime)
    # Not using Yellowknife precip for driving data since only daily precip values available

PCAPAVital <- filter(DrivingPrecip, Station=="CAPAVital")
PCAPAVital <- PCAPAVital %>%
  rename(PCAPAVital=Precip_rate) %>%
  select(DateTime, PCAPAVital)

PVital <- filter(DrivingPrecip, Station=="Vital")
PVital <- PVital %>%
  rename(PVital=Precip_rate) %>%
  select(DateTime, PVital)

PrecipComb <- PCAPAVital
PrecipComb <- merge(PrecipComb, PVital, by="DateTime", all=TRUE)
PrecipComb$Combined <- NA
PrecipComb <- filter(PrecipComb, is.na(DateTime)==FALSE)

PrecipComb$Combined[is.na(PrecipComb$Combined)] <- paste0(PrecipComb$PVital[is.na(PrecipComb$Combined)])
PrecipComb$Combined <- as.double(PrecipComb$Combined)
PrecipComb$Combined[is.na(PrecipComb$Combined)] <- paste0(PrecipComb$PCAPAVital[is.na(PrecipComb$Combined)])
PrecipComb$Combined <- as.double(PrecipComb$Combined)

#Plot and check the combination
    # Calculate annual totals and compare the Combined with all CAPA values and with YellowknifeA
PrecipCombDaily <- select(PrecipComb, DateTime, Combined)
PrecipCombDaily$Station <- "Combined"
PrecipCombDaily <- PrecipCombDaily %>%
  mutate(Amount=Combined*3600*0.5) %>%
  mutate(Date=date(DateTime)) %>%
  group_by(Date, Station) %>%
  summarise(DailyPrecip=sum(Amount)) %>%
  ungroup()

Check <- rbind(PrecipCombDaily, CAPADaily, YknifePrecipDaily, VitalPrecipDaily)
Check <- Check %>%
  mutate(Year=year(Date)) %>%
  group_by(Year, Station) %>%
  summarise(AnnualPrecip=sum(DailyPrecip, na.rm=TRUE))

ggplot()+
  geom_col(data=Check, position="dodge", mapping=aes(x=Year, y=AnnualPrecip, fill=Station), color="gray27") +
  labs(title="Annual Precip Comparison with Combined")
  # scale_fill_discrete_diverging(pal(3))

save(PrecipComb, file="C:/Users/haley/OneDrive/Documents/1.MWS2018-2019/T2/Project/ECCC_Project/R Code/PrecipComb.Rda")

setwd("C:/Users/haley/OneDrive/Documents/1.MWS2018-2019/T2/Project/ECCC_Project/R Code/")
PrecipFinal <- select(PrecipComb, DateTime, Combined)
PrecipWrite <- select(PrecipComb, Combined)
write_excel_csv(PrecipFinal, "../MESH Model/Baker Creek Model Files/basin_rain.xlsx.csv")
write_tsv(PrecipWrite, "../MESH Model/Baker Creek Model Files/basin_rain.csv", col_names=FALSE)

##### Decide start date for the model (no recent rain events)
RecentRain <- filter(PrecipComb, year(DateTime)==2005 & month(DateTime) %in% c(09, 10))
RecentRain <- RecentRain %>%
  select(DateTime, Combined) %>%
  mutate(Amount=Combined*3600*0.5) %>%
  mutate(Date=date(DateTime)) %>%
  group_by(Date) %>%
  summarise(DailyPrecip=sum(Amount)) %>%
  ungroup()
  