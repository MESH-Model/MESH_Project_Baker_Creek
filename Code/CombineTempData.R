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

#####Check that the column names are consistent
# ColNames_Vital <- colnames(Vital)
# ColNames_Landing <- colnames(Landing)
# ColNames_Yknife <- colnames(Yknife)
# ColNames_GEM <- colnames(GEM_data)
# 
# Check_Colnames <- data.frame(ColNames_Vital, ColNames_Landing, ColNames_Yknife, ColNames_GEM)

#####Shift the 2009 Vital data back by 6 days to match the Yellowknife and GEM data
p <- period(6, units="day")
VitalShift09 <- mutate(Vital, DateTime=if_else(year(DateTime)==2009,DateTime-p,DateTime))

#####Check that "Vital" matches the original data where the first point: T_2m=0.22843, T_4.4m=-0.04837, u_4.4m=5.247
# Vital09Only <- filter(Vital, year(DateTime)==2009)
# VitalShift09Only <- filter(VitalShift09, year(DateTime)==2009)
# head(Vital09Only)
# head(VitalShift09Only)

#VitalShift09 <- filter(VitalShift09, year(DateTime)==2009)
#VitalShift09$DateTimeShift <- ymd_hms(VitalShift09$DateTimeShift)

#####Combine all the data
##Use this first section to choose whether or not to use the shifted version of the Vital data, or the original

DrivingShift <- rbind(VitalShift09, Landing, Yknife, GEM_data)
DrivingOrig <- rbind(Vital, Landing, Yknife, GEM_data)

#####Count the number of observations at each station for each variable between Sept. 1 2005 and Oct. 1 2018 (inclusive); I used this when trying to check what % of the entire dataset each station makes up for each variable; didn't actually complete the calculation
# Driving_subset <- filter(Driving, DateTime >= "2005-09-01 00:00:00" & DateTime <= "2018-10-01 23:30:00")
# Driving_subset <- Driving_subset %>%
#   select(Station, T_40m) %>%
#   group_by(Station) %>%
#   summarise_each(~n())
# Driving_subset <- Driving_subset %>%
#   gather(ColNames_Vital[3:25], key="Obs", value="Value") %>%
#   group_by(Station, Obs) %>%
#   filter(is.na(Value)==FALSE) %>%
#   summarise_at("Value", ~n(), na.rm=TRUE)

##### Explore the temperature data
# Temp <- select(Driving, DateTime, Station, T_1.1m, T_2m, T_4.4m, T_40m)
# Temp1 <- Temp
# Temp1 <- Temp1 %>% gather(T_1.1m, T_2m, T_4.4m, T_40m, key="Height", value="T_degC")%>%
#   arrange(DateTime) %>%
#   filter(is.na(T_degC)==FALSE) %>%
#   filter(!Station %in% c("GEMLanding", "GEMYellowknifeA", "Landing")) %>%
#   mutate(Year = year(DateTime), Date=date(DateTime), Month=month(DateTime), Day=day(DateTime), Time=paste(hour(DateTime),minute(DateTime),second(DateTime),sep=":")) %>%
#   group_by(Date, Station, Height) %>%
#   summarise(DailyAvgT=mean(T_degC))

# Temp1$Height <- str_sub(Temp1$Height, start=3)
# # Temp <- group_by("Station")
# 
# Temp1$CommonDate <- as.Date(paste0("2000-", format(Temp1$Date, "%j")),"%Y-%j")
# 
# Temp_05_11 <- filter(Temp1, year(Date)>=2005 & year(Date)<=2011)
# ggplot() +
#   geom_line(data=Temp_05_11, mapping=aes(x=CommonDate, y=DailyAvgT, color=Station), size=0.5) +
#   facet_grid(year(Temp_05_11$Date) ~ .) + 
#   scale_x_date(labels=function(x) format(x,"%d-%b")) + 
#   labs(title="Daily Average Temperature - 2005-2011(shifted)")
# 
# Temp_12_18 <- filter(Temp1, year(Date)>=2012 & year(Date)<=2018)
# ggplot() +
#   geom_line(data=Temp_12_18, mapping=aes(x=CommonDate, y=DailyAvgT, color=Station), size=0.5) +
#   facet_grid(year(Temp_12_18$Date) ~ .) + 
#   scale_x_date(labels=function(x) format(x,"%d-%b")) + 
#   labs(title="Daily Average Temperature - 2012-2018")
#       #Note: 2009 Vital data appears to be shifted forward by a few days compared to the other observations
# 
# Temp_2009 <- Temp1 %>% filter(year(Date)==2009)
# 
# ggplot() +
#   geom_line(data=Temp_2009, mapping=aes(x=CommonDate, y=DailyAvgT, color=Station), size=0.5) +
#   facet_grid(year(Temp_2009$Date) ~ .) + 
#   scale_x_date(labels=function(x) format(x,"%d-%b")) +
#   labs(title="Daily Average Temperature - 2009(shifted)")

#####Calculate the adiabatic lapse rate for the period where there is GEM temp. data at both 2m and 40m (from Oct. 1 2011 onward)
    ### Could look at this code: https://rdrr.io/github/ilyamaclean/microclima/man/lapserate.html
# View(GEM_data)
GEMLapse <- GEM_data
GEMLapse <- GEMLapse %>%
  select(DateTime, Station, T_2m, T_40m) %>%
  filter(Station=="GEMVital", is.na(T_2m)==FALSE) %>%
  mutate(LapseRate=(T_40m-T_2m)/-0.038) %>%
  mutate(Date=date(DateTime))

GEMLapse$CommonDate <- as.Date(paste0("2001-", format(GEMLapse$Date, "%j")),"%Y-%j")

# ggplot() +
#   geom_point(data=GEMLapse, mapping=aes(x=CommonDate, y=LapseRate, color=Station), size=0.5) +
#   facet_grid(year(GEMLapse$Date) ~ .) + 
#   scale_x_date(labels=function(x) format(x,"%d-%b")) + 
#   labs(title="GEM Lapse Rate - 2011-2018")

#Calculate min, mean, and max lapse rates
min(GEMLapse$LapseRate)
mean(GEMLapse$LapseRate)
max(GEMLapse$LapseRate)


#####Adjust the Vital and Yellowknife temperature data up to 40m

# DrivingLapsed <- rbind(VitalShift09, Landing, Yknife, GEM_data)
# LR <- mean(GEMLapse$LapseRate)
LR <- 6.5
Temp2 <- select(DrivingShift, DateTime, Station, T_1.1m, T_2m, T_4.4m, T_40m)
Temp2 <- arrange(Temp2, DateTime)

#First, compare the T_40m values between the stations and the GEM 40m data

Vital2.8 <- select(Temp2, DateTime, Station, T_2m)
Vital2.8 <- Vital2.8 %>%
  filter(Station=="Vital") %>%
  mutate(Vital2.8 = -LR*(40-2.8)/1000+T_2m) %>%
  select(-c(T_2m, Station))

Vital4.4 <- select(Temp2, DateTime, Station, T_4.4m)
Vital4.4 <- Vital4.4 %>%
  filter(Station=="Vital") %>%
  mutate(Vital4.4 = -LR*(40-4.4)/1000+T_4.4m) %>%
  select(-c(T_4.4m, Station))

YknifeLapsed <- select(Temp2, DateTime, Station, T_2m)
YknifeLapsed <- YknifeLapsed %>%
  filter(Station=="YellowknifeA") %>%
  mutate(YellowknifeA = -LR*(40-2)/1000+T_2m) %>%
  select(-c(T_2m, Station))

GEM40 <- select(Temp2, DateTime, Station, T_40m)
GEM40 <- GEM40 %>%
  filter(Station=="GEMVital") %>%
  filter(year(DateTime)>=2005) %>%
  rename(GEMVital=T_40m) %>%
  select(-Station)

##### Explore and plot the lapsed temp values from various stations
# TempLapsed <- rbind(Vital1.1, Vital4.4, YknifeLapsed, GEM40)
# 
# TempLapsed <- arrange(TempLapsed, DateTime)
# 
# TempLapsed <- spread(TempLapsed, Station, T_40m)
# 
# TempLapsed$Date <- date(TempLapsed$DateTime)
# TempLapsed <- TempLapsed %>%
#   group_by(Date, Station) %>%
#   summarise(DailyAvgT=mean(T_40m))
# 
# TempLapsed$CommonDate <- as.Date(paste0("2001-", format(TempLapsed$Date, "%j")),"%Y-%j")
# # TempLapsed <- filter(TempLapsed, is.na(CommonDate)==FALSE)
# 
# TLapse0511 <- filter(TempLapsed, year(Date)>=2005 & year(Date) <= 2011)
# ggplot() +
#   geom_line(data=TLapse0511, mapping=aes(x=CommonDate, y=DailyAvgT, color=Station), size=0.5) +
#   facet_grid(year(TLapse0511$Date) ~ .) + 
#   scale_x_date(labels=function(x) format(x,"%d-%b")) + 
#   labs(title="Temp at 40m 2005-2011 (Lapse Rate = -24.44 degC/km))")
# 
# TLapse05 <- filter(TempLapsed, year(Date)==2005)
# 
# ggplot() +
#   geom_line(data=TLapse05, mapping=aes(x=CommonDate, y=DailyAvgT, color=Station), size=0.5) +
#   facet_grid(year(TLapse05$Date) ~ .) + 
#   scale_x_date(labels=function(x) format(x,"%d-%b")) + 
#   labs(title="Temp at 40m (Lapse Rate = -24.44 degC/km)")

#####  Combine the temperature data
TComb <- GEM40
TComb <- merge(TComb, YknifeLapsed, by="DateTime", all=TRUE)
TComb <- merge(TComb, Vital2.8, by="DateTime", all=TRUE)
TComb <- merge(TComb, Vital4.4, by="DateTime", all=TRUE)
TComb$Combined <- NA
TComb <- filter(TComb, is.na(DateTime)==FALSE)

TComb$Combined[is.na(TComb$Combined)] <- paste0(TComb$Vital4.4[is.na(TComb$Combined)])
TComb$Combined <- as.double(TComb$Combined)
TComb$Combined[is.na(TComb$Combined)] <- paste0(TComb$Vital2.8[is.na(TComb$Combined)])
TComb$Combined <- as.double(TComb$Combined)
TComb$Combined[is.na(TComb$Combined)] <- paste0(TComb$YellowknifeA[is.na(TComb$Combined)])
TComb$Combined <- as.double(TComb$Combined)
TComb$Combined[is.na(TComb$Combined)] <- paste0(TComb$GEMVital[is.na(TComb$Combined)])
TComb$Combined <- as.double(TComb$Combined)

#Convert to degrees kelvin
TComb <- TComb %>%
  mutate(CombinedK=(Combined+273.15))

save(TComb, file="TempScaledCombined.Rda")

TFinal <- select(TComb, DateTime, CombinedK)
TWrite <- select(TComb, CombinedK)
write_excel_csv(TFinal, "../MESH Model/Baker Creek Model Files/basin_temperature.xlsx.csv")
write_tsv(TWrite, "../MESH Model/Baker Creek Model Files/basin_temperature.csv", col_names=FALSE)

### Plotting the results of the combined temperature data
load("./TempScaledCombined.Rda")
TCombPlot <- TComb
TCombPlot$Date <- date(TCombPlot$DateTime)
TCombPlot <- TCombPlot %>%
  gather(Combined, GEMVital, key="Station", value="T_40m") %>%
  group_by(Date, Station) %>%
  summarise(DailyAvgT=mean(T_40m))
TCombPlot$CommonDate <- as.Date(paste0("2001-", format(TCombPlot$Date, "%j")),"%Y-%j")

TCombPlot_05_11 <- filter(TCombPlot, year(Date) %in% 2005:2011)
ggplot(data=TCombPlot_05_11) +
  geom_line(mapping=aes(x=CommonDate, y=DailyAvgT, colour=Station), size=0.5) +
  # geom_line(mapping=aes(x=CommonDate, y=GEM40), size=0.5) +
  facet_grid(year(TCombPlot_05_11$Date) ~ .) +
  scale_x_date(labels=function(x) format(x,"%d-%b")) +
  labs(title="Temperature Data")

##### Look at the temperature data around where the model will start (2005)
TStart <- filter(TComb, year(DateTime)==2005 & month(DateTime) %in% c(09, 10))
TStart <- TStart %>%
  select(DateTime, Combined) %>%
  mutate(Date=date(DateTime)) %>%
  group_by(Date) %>%
  summarise(DailyAvgT=mean(Combined)) %>%
  ungroup()

##### Get the daily average temperature on Sept. 14 for use as the starting TCAN in the model
Tstart <- filter(TComb, date(DateTime)=='2005-09-14')
TCAN <- summarise(Tstart, Tavg=mean(Combined))
