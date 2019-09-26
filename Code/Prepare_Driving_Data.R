#The purpose of this script is to gather, inspect, clean, and compile the driving data for Haley and Sadiq's MWS Capstone Projects

#Load libraries
library(tidyverse)
library(dplyr)
library(lubridate)
library(zoo)

#---------------------------------------------------------------------------------------------------
#LOAD DATA

  #Vital Tower
colnames_vital=c('Year', 'DateTime', 'AirP', 'Kin', 'Kout', 'Lin', 'Lout', 'Qstar', 'T_4.4m', 'RH_4.4m', 'T_2m', 'RH_2m', 'u_4.4m', 'Rain_mm', 'Qe', 'Qh')

Vital_load <- read_csv(file="C:/Users/haley/OneDrive/Documents/1.MWS2018-2019/T2/Project/ECCC_Project/Data/ESSD Baker Creek Data/HydrometeorologicalData/vital tower half hourly time series v1.csv", col_names = colnames_vital, skip=1)
    #Units are: kPa, W/m2, degC, %, m/s, and mm 

#Fix the format of the DateTime column
Vital_load$DateTime <- dmy_hm(Vital_load$DateTime)
Vital <- Vital_load
Vital$DateTime <- force_tz(Vital$DateTime,tzone="America/Yellowknife")
head(Vital)

#Replace all "9999" values with "NA"
Vital[Vital==9999]<- NA
Vital[Vital==99999]<- NA

#Convert air pressure from kPa to Pa (replace)
#Convert RH to specific humidity (replace; use T at the same height as RH for conversion), and
#Add a precip rate (mm/s) column;
    
    #Specific humidity in kg kg-1 is given as: 
      #qa =  0.622ea / (Pa - 0.378 ea)
          # where:qa = Specific humidity in kg kg-1
          # Pa = Surface pressure in Pa
          # ea = Vapour pressure:
          # ea = rh10^[(0.7859 + 0.03477Ta)/(1.0 + 0.00412Ta) + 2]
              # where:  
              # Ta  = Air temperature in °C
              # rh = Relative humidity in %

Vital <- Vital %>% 
  mutate(AirP_Pa=AirP*1000) %>%
  mutate(ea_4.4m=RH_4.4m/100*10^((0.7859+0.03477*T_4.4m)/(1.0+0.00412*T_4.4m)+2))%>%
  mutate(q_4.4m=0.622*ea_4.4m/(AirP_Pa-0.378*ea_4.4m)) %>%
  mutate(ea_2m=RH_2m/100*10^((0.7859+0.03477*T_2m)/(1.0+0.00412*T_2m)+2))%>%
  mutate(q_2m=0.622*ea_2m/(AirP_Pa-0.378*ea_2m)) %>%
  # mutate(qa_4.4m=0.622*RH_4.4m/100*611*exp(17.27*T_4.4m/(T_4.4m+237.3))/AirP_Pa) %>%
  # mutate(qa_1.1m=0.622*RH_1.1m/100*611*exp(17.27*T_1.1m/(T_1.1m+237.3))/AirP_Pa) %>%
  mutate(Rain_rate=Rain_mm/0.5/3600) #Convert mm/0.5 hr to mm/s

#Remove unneeded columns (AirP(kPa), RH, and ea(intermediate calculation))
Vital <- Vital %>% select(-c(AirP,ea_4.4m, ea_2m, Year))

#Check specific humidity calculation using Dingman eq'n 3.9a, 3.11 and 3.12
#write_csv(Vital,"Vital_Check.csv")
# RH = 51.975 #Percent
# Ta = 16.791 #degrees C
# Pa = 97641 #Air pressure, Pa
# 
# e=611*exp(17.27*Ta/(Ta+237.3))
# q=0.622*RH/100*611*exp(17.27*Ta/(Ta+237.3))/Pa
# 
# ea=RH/100*10^((0.7859+0.03477*Ta)/(1.0+0.00412*Ta)+2)
# q_wiki=0.622*ea/(Pa-0.378*ea)

#Add missing columns and re-order columns
full_colnames <- read_csv("met_variable_names.csv")
full_colnames <- colnames(full_colnames)
Vital_cols <- colnames(Vital)
missing_colnames <- setdiff(full_colnames,Vital_cols)
Vital[,missing_colnames] <- NA
Vital$Station <- "Vital"
Vital$Precip_rate <- Vital$Rain_rate

Vital <- Vital[, full_colnames]

#Remove rows that are all NA
Vital <- Vital[rowSums(is.na(Vital))!= ncol(Vital)-2,]

save(Vital, file="Vital.Rda")

#qplot(data=Vital,x=DateTime, y=T_4.4m, geom='point')
#qplot(data=Vital,x=DateTime, y=AirP_Pa, geom='point')

#__________________________________
  #Landing Tower
colnames_landing=c('DateTime', 'u_1.1m', 'u_dir', 'T_1.1m', 'e_1.1m', 'Qstar', 'Kin', 'Kout', 'Twater', 'Qe', 'Qh')

Landing_load <- read_csv(file="C:/Users/haley/OneDrive/Documents/1.MWS2018-2019/T2/Project/ECCC_Project/Data/ESSD Baker Creek Data/HydrometeorologicalData/landing tower half hourly time series v1.csv",col_names=colnames_landing, skip=1)
    #Units are: kPa, W/m2, degC, %, m/s, and mm; Actual meas. height of T and e is 1.4 m; labelled as 1.1m for simplification with other datasets

#Fix the format of the DateTime column
Landing_load$DateTime <- dmy_hm(Landing_load$DateTime)
Landing <- Landing_load
Landing$DateTime <- force_tz(Landing$DateTime,tzone="America/Yellowknife")

#Replace all "9999" values with "NA"
Landing[Landing==9999]<- NA

#Convert e to specific humidity (replace; use T at the same height as e and air pressure from Vital for conversion)
Vital_AirP <- tibble(DateTime=Vital$DateTime, Vital_AirP_Pa=Vital$AirP_Pa)

Landing <- merge(x=Landing,y=Vital_AirP, by="DateTime", all=TRUE)

Landing <- Landing %>%
  mutate(e_1.1m=e_1.1m*1000) %>% #Convert kPa to Pa
  mutate(q_1.1m=0.622*e_1.1m/(Vital_AirP_Pa-0.378*e_1.1m))

#Remove unneeded columns (used for intermediate calculation)
Landing <- Landing %>% select(-c(u_dir,Twater,Vital_AirP_Pa, ea_1.1m))

#Add missing columns and re-order columns
full_colnames <- read_csv("met_variable_names.csv") #This was done above
full_colnames <- colnames(full_colnames)
Landing_cols <- colnames(Landing)
missing_colnames <- setdiff(full_colnames,Landing_cols)
Landing[,missing_colnames] <- NA
Landing$Station <- "Landing"

Landing <- Landing[, full_colnames]

#Remove rows that are all NA
Landing <- Landing[rowSums(is.na(Landing))!= ncol(Landing)-2,]

save(Landing, file="Landing.Rda")

#qplot(data=Landing,x=DateTime, y=T_1.1m, geom='point')

# ggplot(data=Landing) +
  # facet_grid(year(Landing$DateTime) ~ .) +
  # geom_line(mapping=aes(x=month(Landing$DateTime), y=T_1.1m))
  
# qplot(data=Landing,x=DateTime, y=Kin, geom='point')

#__________________________________
  #GEM
    #Load the files 
GEMFiles <- list.files(path="C:/Users/haley/Documents/1. MWS 2018-2019/T2/ECCC Project_Cdrive/GEM_CaPA_Data", pattern=glob2rx("rdps*.csv"))
GEMFiles

file_names <- c("Lin", "AirP_Pa", "Kin", "q_2m", "q_40m", "T_2m_degC","T_2m_degK","T_40m_degC", "T_40mdegK", "u_10m", "u_40m")
    #Units: W/m2, Pa, kg/kg, degrees C, degrees K, m/s; no need to do conversions

setwd("C:/Users/haley/Documents/1. MWS 2018-2019/T2/ECCC Project_Cdrive/GEM_CaPA_Data")
i=1
colNames_GEM=c("DateTime", "GEMYellowknifeA", "GEMLanding", "GEMVital")
for(x in GEMFiles) {
  assign(file_names[i],read_csv(x,skip=3,col_names=colNames_GEM))  #Read the file and assign name
  i=i+1
}

#Change the hourly GEM timeseries to halfhourly using the user-defined "oneToHalfHr" function
      # If you want to assign values to the half hour by interpolating, pass interpolate=1,                otherwise interpolate=0 will assign the hour value to the following half hour

      #This block of code was for testing purposes
      #Lin_test <- Lin
      #Lin_test <- filter(Lin_test, DateTime <= "2005-05-18 17:00:00")
          ### Note: this is returning the last value at 2005-05-18 23:00:00, which is UTC+6

oneToHalfHr <- function(myData, interpolate) {
  p <- period(30, unit="minutes")
  HalfHourly <- myData
  if (interpolate == 1) {
    HalfHourly[,1] <- pull(HalfHourly[,1]) - p
    for (i in 2:ncol(myData)){
      HalfHourly[,i] <- rollmean(myData[,i], 2, align="right", fill=NA)
    }
    HalfHourly <- HalfHourly[-1,]
  } else {
    HalfHourly[,1] <- pull(HalfHourly[,1]) + p
    #HalfHourly <- HalfHourly[-nrow(HalfHourly),]
  }
  myData <- rbind(myData, HalfHourly)
  myData <- arrange(myData,DateTime)
}

Lin <- oneToHalfHr(Lin,1)
Kin <- oneToHalfHr(Kin,1)
AirP_Pa <- oneToHalfHr(AirP_Pa,1)
q_2m <- oneToHalfHr(q_2m,1)
q_40m <- oneToHalfHr(q_40m,1)
T_2m_degC <- oneToHalfHr(T_2m_degC,1)
T_2m_degK <- oneToHalfHr(T_2m_degK,1)
T_40m_degC <- oneToHalfHr(T_40m_degC,1)
T_40mdegK <- oneToHalfHr(T_40mdegK,1)
u_10m <- oneToHalfHr(u_10m,1)
u_40m <- oneToHalfHr(u_40m,1)

#Test if the average is preserved
ColNamesu_10m <- colnames(u_10m)
Avg_check <- summarise_each(u_10m, fun=mean, ColNamesu_10m[-1])
Avg_check[2,] <- summarise_each(u_10m2, fun=mean, ColNamesu_10m[-1])
Avg_check[3,] <- summarise_each(Avg_check, fun=diff, ColNamesu_10m[-1])

##### Using the interpolation method, the mean is of by about 0.0002%; Using the stepwise method, there is no difference in the mean

#Gather and combine all the datasets; couldn't figure out how to do this in a loop
      #First, create the Dataset
Lin <- gather(Lin,'GEMYellowknifeA', 'GEMLanding', 'GEMVital', key="Station", value='Lin')
GEM_data <- Lin

      #Then gather each value and add to the combined dataset, GEM_data
AirP_Pa <- gather(AirP_Pa,'GEMYellowknifeA', 'GEMLanding', 'GEMVital', key="Station", value='AirP_Pa')
GEM_data <- merge(x=GEM_data, y=AirP_Pa, by=c("DateTime","Station"), all=TRUE)

Kin <- gather(Kin,'GEMYellowknifeA', 'GEMLanding', 'GEMVital', key="Station", value='Kin')
GEM_data <- merge(x=GEM_data, y=Kin, by=c("DateTime","Station"), all=TRUE)

q_2m <- gather(q_2m,'GEMYellowknifeA', 'GEMLanding', 'GEMVital', key="Station", value='q_2m')
GEM_data <- merge(x=GEM_data, y=q_2m, by=c("DateTime","Station"), all=TRUE)

q_40m <- gather(q_40m,'GEMYellowknifeA', 'GEMLanding', 'GEMVital', key="Station", value='q_40m')
GEM_data <- merge(x=GEM_data, y=q_40m, by=c("DateTime","Station"), all=TRUE)

T_2m_degC <- gather(T_2m_degC,'GEMYellowknifeA', 'GEMLanding', 'GEMVital', key="Station", value='T_2m')
GEM_data <- merge(x=GEM_data, y=T_2m_degC, by=c("DateTime","Station"), all=TRUE)

T_40m_degC <- gather(T_40m_degC,'GEMYellowknifeA', 'GEMLanding', 'GEMVital', key="Station", value='T_40m')
GEM_data <- merge(x=GEM_data, y=T_40m_degC, by=c("DateTime","Station"), all=TRUE)

u_10m <- gather(u_10m,'GEMYellowknifeA', 'GEMLanding', 'GEMVital', key="Station", value='u_10m')
GEM_data <- merge(x=GEM_data, y=u_10m, by=c("DateTime","Station"), all=TRUE)

u_40m <- gather(u_40m,'GEMYellowknifeA', 'GEMLanding', 'GEMVital', key="Station", value='u_40m')
GEM_data <- merge(x=GEM_data, y=u_40m, by=c("DateTime","Station"), all=TRUE)

#Not including T_2m_degK or T_40m_degK -> will convert all temps to K later 

setwd("C:/Users/haley/OneDrive/Documents/1.MWS2018-2019/T2/Project/ECCC_Project/R Code/")

#Convert the GEM data to Local time in Yellowknife (UTC-7)
GEM_data <- GEM_data %>% 
  mutate(DateTime=update(DateTime,hour=hour(DateTime)-7))
  #add_column(Unit='W m-2', Height='', Observation='LWin')
  #gather(x, 'YellowknifeA', 'Landing', 'Vital',key='Location', value='Observation')

#Add missing columns and rearrange to match other datasets
load("./GEM_data.Rda")
full_colnames <- read_csv("met_variable_names.csv") #This was done above
full_colnames <- colnames(full_colnames)
GEM_cols <- colnames(GEM_data)
missing_colnames <- setdiff(full_colnames,GEM_cols)
GEM_data[,missing_colnames] <- NA

GEM_data <- GEM_data[, full_colnames]
GEM_data$DateTime <- force_tz(GEM_data$DateTime, tzone="America/Yellowknife")

save(GEM_data, file="GEM_data.Rda")

#__________________________________
  #CaPA

setwd("C:/Users/haley/Documents/1. MWS 2018-2019/T2/ECCC Project_Cdrive/GEM_CaPA_Data")
colNames_CAPA=c("DateTime", "CAPAYellowknifeA", "CAPALanding", "CAPAVital")
CAPA_load <- read_csv("rdpa_rain_nearest_20020101_20190101.csv",skip=3,col_names=colNames_CAPA)  

#Convert the CAPA data to Local time in Yellowknife (UTC-7)
CAPA_data <- CAPA_load
CAPA_data <- CAPA_data %>% 
  mutate(DateTime=update(DateTime,hour=hour(DateTime)-7))

#Change the CAPA 6 hr timeseries into 1/2 hour timeseries and backfill the values of precip rate
    # Created a spreadsheet to manually create the timeseries
    # Found out later could do it this way:
          # dates_seq <- seq(as.POSIXct("2015-01-01"), as.POSIXct("2018-12-31"), by=(30))
          # dates_seq <- tibble(dates_seq)

# write.csv(CAPA_data_0.5hr,"C:/Users/haley/OneDrive/Documents/1.MWS2018-2019/T2/Project/ECCC_Project/R Code/CAPA_timeseries.csv")

CAPA_data <- CAPA_data %>% filter(year(DateTime)>=2005)

CAPA_data_0.5hr <- read_csv("C:/Users/haley/OneDrive/Documents/1.MWS2018-2019/T2/Project/ECCC_Project/R Code/CAPA_timeseries.csv", skip=0, col_names="DateTime") 
      #This is a half-hourly timeseries in the 1st column with no heading
CAPA_data_0.5hr$DateTime <- ymd_hm(CAPA_data_0.5hr$DateTime)

head(CAPA_data_0.5hr)

#This takes a long time to run but it works
CAPA0.5_row=1
CAPA_row=1
numit=nrow(CAPA_data_0.5hr)/12
for (i in 1:numit){
  for (j in 1:12){
    CAPA_data_0.5hr[CAPA0.5_row,2] <- CAPA_data[CAPA_row,2]
    CAPA_data_0.5hr[CAPA0.5_row,3] <- CAPA_data[CAPA_row,3]
    CAPA_data_0.5hr[CAPA0.5_row,4] <- CAPA_data[CAPA_row,4]
    CAPA0.5_row=CAPA0.5_row+1
  }
  CAPA_row=CAPA_row+1
}

#write.csv(CAPA_data_0.5hr,"C:/Users/haley/OneDrive/Documents/1.MWS2018-2019/T2/Project/ECCC_Project/R Code/CAPA_timeseries.csv")

CAPA_data_0.5hr <- gather(CAPA_data_0.5hr,'CAPAYellowknifeA', 'CAPALanding', 'CAPAVital', key="Station", value='Precip_rate')

setwd('C:/Users/haley/OneDrive/Documents/1.MWS2018-2019/T2/Project/ECCC_Project/R Code/')

save(CAPA_data_0.5hr, file='CAPA_data_0.5hr.Rda')

#__________________________________

  #Yellowknife Hourly Met Data
  
setwd('C:/Users/haley/OneDrive/Documents/1.MWS2018-2019/T2/Project/ECCC_Project/R Code/')
load('yknife_all_hr.Rda')
Yknife <- yknife_all_hr
# glimpse(Yknife)
# head(Yknife$date)
# tail(Yknife$date)

#Select only the variables needed and rename the columns
Yknife_cols <- colnames(Yknife)
Yknife <- select(Yknife,time,pressure, rel_hum, temp, wind_spd)
Yknife <- rename(Yknife, DateTime=time, AirP=pressure, RH_2m=rel_hum, T_2m=temp, u_10m=wind_spd)
    #Assumed temperature an humidity are at a height of 2m
Yknife_cols <- colnames(Yknife)

#Convert AirPressure to Pa from kPa, RH to q, and u from km/h to m/s
Yknife <- Yknife %>% 
  mutate(AirP_Pa=AirP*1000) %>%
  mutate(ea_2m=RH_2m/100*10^((0.7859+0.03477*T_2m)/(1.0+0.00412*T_2m)+2))%>%
  mutate(q_2m=0.622*ea_2m/(AirP_Pa-0.378*ea_2m)) %>% 
  mutate(u_10m=u_10m/3.6)
  # mutate(qa_4.4m=0.622*RH_4.4m/100*611*exp(17.27*T_4.4m/(T_4.4m+237.3))/AirP_Pa) #Dingman eq'ns

#Remove unneeded columns (AirP(kPa), RH, and ea(intermediate calculation))
Yknife <- Yknife %>% select(-c(AirP))

#Add missing columns and re-order columns
full_colnames <- read_csv("met_variable_names.csv") #This was done above
full_colnames <- colnames(full_colnames)
Yknife_cols <- colnames(Yknife)
missing_colnames <- setdiff(full_colnames,Yknife_cols)
Yknife[,missing_colnames] <- NA
Yknife$Station <- "YellowknifeA"

Yknife <- Yknife[, full_colnames]
Yknife_1hr <- Yknife
save(Yknife_1hr, file="Yknife_1hr.Rda")

load("./Yknife_1hr.Rda")
Yknife <- filter(Yknife, DateTime > "2005-01-01 00:00:00", DateTime <= "2019-01-01 00:00:00")

#Convert Yellowknife Data to Half Hourly using interpolation between the hourly points
  p <- period(30, unit="minutes")
  HalfHourly <- Yknife
  HalfHourly[,1] <- pull(HalfHourly[,1]) - p
    for (i in 3:ncol(Yknife)){
      #To interpolate between hourly observations for the half-hourly, use these lines:
      HalfHourly[,i] <- rollmean(Yknife[,i], 2, align="right", fill=NA)
    }
    HalfHourly <- HalfHourly[-1,]

    #If don't want to interpolate, use these lines instead:
      #HalfHourly[,1] <- pull(HalfHourly[,1]) + p
      #HalfHourly <- HalfHourly[-nrow(HalfHourly),]
  Yknife <- rbind(Yknife, HalfHourly)
  Yknife <- arrange(Yknife,DateTime)

  save(Yknife, file="Yknife_HalfHr.Rda")
#__________________________________

  #Yellowknife Daily Precip Data
  
#Load Yellowknife Precip Data
load('yknife_all_day.Rda')
Yknife_precip <- yknife_all_day
Yknife_precip <- Yknife_precip %>% 
  select(c(date, total_precip, total_rain, total_snow, snow_grnd)) %>%
  filter(year(Yknife_precip$date)>=2005) %>%
  rename(DateTime=date)

head(Yknife_precip)

Yknife_precip <- Yknife_precip %>% add_column("NewDate"="00:00") %>%
  mutate(DateTime=paste(DateTime,NewDate,sep=" ")) %>%
  select(-NewDate)
  
Yknife_precip$DateTime <- ymd_hm(Yknife_precip$DateTime)

save(Yknife_precip, file="Yknife_precip.Rda")

