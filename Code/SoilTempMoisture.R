#This scritp is used to produce tables of minimum, mean, and maximum soil temperature and moisture observations for the dates specified at surface and 25cm depth in the Baker Creek watershed, NWT

#Data source: Spence, C., & Hedstrom, N. (2018). Hydrometeorological data from Baker Creek Research Watershed, Northwest Territories, Canada. Earth System Science Data, 10(4), 1753-1767.

library(tidyverse)
library(lubridate)
library(dplyr)

#Load Soil Temperature and Soil Moisture Data
ColNames <- c("DateTime", "wb_surf", "wb_25cm", "av_surf", "av_25cm", "lp_surf", "lp_25cm", "tp_surf", "tp_25cm", "cv_surf", "cv_25cm")
ColNames_Rock <- c("DateTime", "T_surf", "T_10cm", "T_20cm", "T_30cm", "T_46cm")
SoilT_load <- read_csv('../Data/ESSD Baker Creek Data/GroundTemperatureData/soil temperature time series v1.csv',col_names=ColNames, skip=1)
SoilM_load <- read_csv('../Data/ESSD Baker Creek Data/SoilMoistureData/soil moisture time series v1.csv',col_names=ColNames, skip=1)
RockT_load <- read_csv('../Data/ESSD Baker Creek Data/GroundTemperatureData/exposed rock temperature time series v1.csv',col_names=ColNames_Rock, skip=1)

#Change date formate to dttm
SoilT_load$DateTime <- dmy_hm(SoilT_load$DateTime)
SoilM_load$DateTime <- dmy_hm(SoilM_load$DateTime)
RockT_load$DateTime <- dmy(RockT_load$DateTime)
head(SoilT_load)
head(SoilM_load)

#Remove the DateTime name from column names for use in the "gather" function", then gather the data, and add a Landuse column
ColNames <- ColNames <- c("wb_surf", "wb_25cm", "av_surf", "av_25cm", "lp_surf", "lp_25cm", "tp_surf", "tp_25cm", "cv_surf", "cv_25cm")
SoilT <- SoilT_load #To preserve the original loaded values
SoilM <- SoilM_load #To preserve the original loaded values
RockT <- RockT_load

SoilT <- SoilT %>%                                    #This block for Soil Temp
  gather(ColNames, key="Station", value="SoilTemp") %>%
  separate(Station, c("Location", "T_Depth")) %>%
  filter(!SoilTemp==9999) %>%
  mutate(Landuse=ifelse(Location=="lp"|Location=="cv","Hillslope",ifelse(Location=="wb"|Location=="tp","Peatland","Wetland")))

# unique(SoilT$SoilTemp)
# unique(SoilT$T_Depth)
# unique(SoilT$Location)

SoilM <- SoilM %>%                                    #This block for Soil Moisture
  gather(ColNames, key="Station", value="SoilMoist") %>%
  separate(Station, c("Location", "M_Depth")) %>%
  filter(!SoilMoist==9999)%>% 
  mutate(Landuse=ifelse(Location=="lp"|Location=="cv","Hillslope",ifelse(Location=="wb"|Location=="tp","Peatland","Wetland")))
# unique(SoilM$SoilMoist)
# unique(SoilM$M_Depth)
# unique(SoilM$Location)

#Calculate the min, max, and average SOIL TEMP on Sept 15 at 25cm and surface for all locations and overall
Sept15_avgT <- filter(SoilT, month(DateTime)==9, day(DateTime)==15)

Sept15_avgT <- Sept15_avgT %>%
  spread(key=T_Depth, value=SoilTemp,sep='_')

Total <- c("Overall",min(Sept15_avgT$T_Depth_25cm,na.rm=TRUE),min(Sept15_avgT$T_Depth_surf,na.rm=TRUE),mean(Sept15_avgT$T_Depth_25cm,na.rm=TRUE),mean(Sept15_avgT$T_Depth_surf,na.rm=TRUE),max(Sept15_avgT$T_Depth_25cm,na.rm=TRUE),max(Sept15_avgT$T_Depth_surf,na.rm=TRUE))

Sept15_avgT <- Sept15_avgT %>%
  select(-DateTime) %>%
  #group_by(Location) %>%
  group_by(Landuse)%>%
  summarise_each(funs(min(.,na.rm=TRUE), mean(.,na.rm=TRUE), max(.,na.rm=TRUE)), T_Depth_25cm, T_Depth_surf)

Sept15_avgT <- rbind(Sept15_avgT,Total)

#Calculate the min, max, and average SOIL TEMP on Oct. 1 at 25cm and surface for all locations and overall
Oct1_avgT <- filter(SoilT, month(DateTime)==10, day(DateTime)==1)

Oct1_avgT <- Oct1_avgT %>%
  spread(key=T_Depth, value=SoilTemp,sep='_')

tp <- filter(Oct1_avgT, Location=='tp')

Total <- c("Overall",min(Oct1_avgT$T_Depth_25cm,na.rm=TRUE),min(Oct1_avgT$T_Depth_surf,na.rm=TRUE),mean(Oct1_avgT$T_Depth_25cm,na.rm=TRUE),mean(Oct1_avgT$T_Depth_surf,na.rm=TRUE),max(Oct1_avgT$T_Depth_25cm,na.rm=TRUE),max(Oct1_avgT$T_Depth_surf,na.rm=TRUE))

Oct1_avgT <- Oct1_avgT %>%
  # select(-DateTime) %>%
  #group_by(Location) %>%
  group_by(Landuse) %>%
  summarise_each(funs(min(.,na.rm=TRUE), mean(.,na.rm=TRUE), max(.,na.rm=TRUE)), T_Depth_25cm, T_Depth_surf)

Oct1_avgT <- rbind(Oct1_avgT,Total)
      #Note: there are no observations for location 'tp' at 25cm, hence the Inf/NaN values

#Calculate the min, max, and average SOIL MOISTURE on Sept 15 at 25cm and surf for all locations and overall
Sept15_avgM <- filter(SoilM, month(DateTime)==9, day(DateTime)==15)

Sept15_avgM <- Sept15_avgM %>%
  spread(key=M_Depth, value=SoilMoist,sep='_')

Total <- c("Overall",min(Sept15_avgM$M_Depth_25cm,na.rm=TRUE),min(Sept15_avgM$M_Depth_surf,na.rm=TRUE),mean(Sept15_avgM$M_Depth_25cm,na.rm=TRUE),mean(Sept15_avgM$M_Depth_surf,na.rm=TRUE),max(Sept15_avgM$M_Depth_25cm,na.rm=TRUE),max(Sept15_avgM$M_Depth_surf,na.rm=TRUE))

Sept15_avgM <- Sept15_avgM %>%
  select(-DateTime) %>%
  #group_by(Location) %>%
  group_by(Landuse) %>%
  summarise_each(funs(min(.,na.rm=TRUE), mean(.,na.rm=TRUE), max(.,na.rm=TRUE)), M_Depth_25cm, M_Depth_surf)

Sept15_avgM <- rbind(Sept15_avgM,Total)

#Calculate the min, max, and average SOIL MOISTURE on Oct. 1 at 25cm and surf for all locations and overall
Oct1_avgM <- filter(SoilM, month(DateTime)==10, day(DateTime)==1)

Oct1_avgM <- Oct1_avgM %>%
  spread(key=M_Depth, value=SoilMoist,sep='_')

tp <- filter(Oct1_avgM, Location=='tp')

Total <- c("Overall",min(Oct1_avgM$M_Depth_25cm,na.rm=TRUE),min(Oct1_avgM$M_Depth_surf,na.rm=TRUE),mean(Oct1_avgM$M_Depth_25cm,na.rm=TRUE),mean(Oct1_avgM$M_Depth_surf,na.rm=TRUE),max(Oct1_avgM$M_Depth_25cm,na.rm=TRUE),max(Oct1_avgM$M_Depth_surf,na.rm=TRUE))

Oct1_avgM <- Oct1_avgM %>%
  # select(-DateTime) %>%
  #group_by(Location) %>%
  group_by(Landuse) %>%
  summarise_each(funs(min(.,na.rm=TRUE), mean(.,na.rm=TRUE), max(.,na.rm=TRUE)), M_Depth_25cm, M_Depth_surf)

Oct1_avgM <- rbind(Oct1_avgM,Total)
#Note: there are no observations for location 'tp' at 25cm, hence the Inf/NaN values

#Exposed Rock Calculations

RockT <- RockT_load

ColNames_Rock <- c("T_surf", "T_10cm", "T_20cm", "T_30cm", "T_46cm")
RockT <- RockT %>%
  gather(ColNames_Rock, key="Depth", value="RockTemp") %>%
  filter(!RockTemp==9999) %>%
  spread(key=Depth, value=RockTemp)

Sept15_avgRockT <- filter(RockT, month(DateTime)==9, day(DateTime)==15)

Sept15_avgRockT <- Sept15_avgRockT %>% 
  summarise_each(funs(min(.,na.rm=TRUE), mean(.,na.rm=TRUE), max(.,na.rm=TRUE)), T_surf, T_20cm, T_30cm) #%>%

ColOrder <- c("T_surf_min", "T_surf_mean", "T_surf_max", "T_20cm_min", "T_20cm_mean","T_20cm_max", "T_25cm_min", "T_25cm_mean","T_25cm_max","T_30cm_min", "T_30cm_mean","T_30cm_max")

Sept15_avgRockT <- Sept15_avgRockT %>% mutate(T_25cm_min=mean(T_20cm_min, T_30cm_min), T_25cm_mean=mean(T_20cm_mean, T_30cm_mean), T_25cm_max=mean(T_20cm_max, T_30cm_max))
Sept15_avgRockT <- Sept15_avgRockT[,ColOrder]

#October 1 calc
Oct1_avgRockT <- filter(RockT, month(DateTime)==10, day(DateTime)==1)

Oct1_avgRockT <- Oct1_avgRockT %>% 
  summarise_each(funs(min(.,na.rm=TRUE), mean(.,na.rm=TRUE), max(.,na.rm=TRUE)), T_surf, T_20cm, T_30cm) #%>%

ColOrder <- c("T_surf_min", "T_surf_mean", "T_surf_max", "T_20cm_min", "T_20cm_mean","T_20cm_max", "T_25cm_min", "T_25cm_mean","T_25cm_max","T_30cm_min", "T_30cm_mean","T_30cm_max")

Oct1_avgRockT <- Oct1_avgRockT %>% mutate(T_25cm_min=mean(T_20cm_min, T_30cm_min), T_25cm_mean=mean(T_20cm_mean, T_30cm_mean), T_25cm_max=mean(T_20cm_max, T_30cm_max))
Oct1_avgRockT <- Oct1_avgRockT[,ColOrder]

#Calculate Aggregate Soil Temp and Moisture weighted by landcover fraction
#First, for soil Temperature (include Bedrock)
Landcover_frac <- tibble("Type"=c("Bedrock", "Hillslope", "Peatland", "Wetland"), "Fraction"=c(0.3992, 0.2078+0.0075, 0.1007, 0.0585))
sum_frac <- sum(Landcover_frac$Fraction)
sum_frac
Landcover_frac$Fraction <- Landcover_frac$Fraction/sum_frac

Landcover_frac$Oct1_surf_mean <- NA
Landcover_frac$Oct1_25cm_mean <- NA

Landcover_frac[1,3] <- Oct1_avgRockT$T_surf_mean
Landcover_frac[1,4] <- Oct1_avgRockT$T_25cm_mean
Oct1_T <- filter(Oct1_avgT, !Landuse=="Overall")
Landcover_frac[2:4,3] <- (Oct1_T$T_Depth_surf_mean)
Landcover_frac[2:4,4] <- Oct1_T$T_Depth_25cm_mean
Landcover_frac <- mutate(Landcover_frac, Frac_T_surf=Fraction*Oct1_surf_mean, Frac_T_25cm=Fraction*Oct1_25cm_mean)
Landcover_frac$Oct1_surf_mean <- as.numeric(Landcover_frac$Oct1_surf_mean)
Landcover_frac$Oct1_25cm_mean <- as.numeric(Landcover_frac$Oct1_25cm_mean)
head(Landcover_frac)
Total_surf_T <- sum(Landcover_frac$Fraction*Landcover_frac$Oct1_surf_mean)
Total_25cm_T <- sum(Landcover_frac$Fraction*Landcover_frac$Oct1_25cm_mean)

Total_surf_T
Total_25cm_T

#Calculate the weighted average soil moisture on October 1 for the whole watershed
Landcover_frac <- select(Landcover_frac, Type, Fraction)
Landcover_frac <- filter(Landcover_frac, Type!="Bedrock")
sumfrac <- sum(Landcover_frac$Fraction)
Landcover_frac$Fraction <- Landcover_frac$Fraction/sumfrac

Landcover_frac$Oct1_surf_mean <- NA
Landcover_frac$Oct1_25cm_mean <- NA

Oct1_M <- filter(Oct1_avgM, !Landuse=="Overall")
Oct1_M
Landcover_frac$Oct1_surf_mean <- Oct1_M$M_Depth_surf_mean
Landcover_frac$Oct1_25cm_mean <- Oct1_M$M_Depth_25cm_mean
Landcover_frac

Landcover_frac$Oct1_surf_mean <- as.numeric(Landcover_frac$Oct1_surf_mean)
Landcover_frac$Oct1_25cm_mean <- as.numeric(Landcover_frac$Oct1_25cm_mean)

Total_surf_M <- sum(Landcover_frac$Fraction*Landcover_frac$Oct1_surf_mean)
Total_25cm_M <- sum(Landcover_frac$Fraction*Landcover_frac$Oct1_25cm_mean)

Total_surf_M
Total_25cm_M

sum(Landcover_frac$Fraction)

#Do some plotting of the soil temperatures to get a sense of the change with depth and time
ColNames_Rock <- c("T_surf", "T_10cm", "T_20cm", "T_30cm", "T_46cm")
RockT_plot <- gather(RockT, ColNames_Rock, key="Depth", value="RockTemp")
RockT_plot <- mutate(RockT_plot, Year=year(DateTime))
RockT_plot <- mutate(RockT_plot, JDay=yday(DateTime))

SoilT_plot <- mutate(SoilT, Year=year(DateTime), JDay=yday(DateTime), MonthDay=month(DateTime))
SoilT_plot <- filter(SoilT_plot, month(DateTime)==9 | month(DateTime)==10)

ggplot() + 
  geom_line(data=SoilT_plot, mapping=aes(x=JDay, y=SoilTemp,color=T_Depth)) + 
  facet_grid(Year ~ .)

ggplot() + 
  geom_line(data=SoilT_plot, mapping=aes(x=JDay, y=SoilTemp,color=T_Depth)) + 
  facet_grid(Year ~ .)

#Obtaining the air temperature of the canopy on October 1, 2005 (assuming = air temp)
#Note: Vital has no data so use Yellowknife Data
load('C:/Users/haley/OneDrive/Documents/1.MWS2018-2019/T2/Project/ECCC_Project/R Code/Yknife.Rda')
head(Yknife)
Oct1_TCAN <- filter(Yknife, date(DateTime)=="2005-10-01")
Oct1_TCAN <- mean(Oct1_TCAN$T_2m)
Oct1_TCAN

#Obtaining the ponding temperature; use Twater from the Landing data
colnames_landing=c('DateTime', 'u_1.1m', 'u_dir', 'T_1.1m', 'e_1.1m', 'Qstar', 'Kin', 'Kout', 'Twater', 'Qe', 'Qh')

Landing_load <- read_csv(file="C:/Users/haley/OneDrive/Documents/1.MWS2018-2019/T2/Project/ECCC_Project/Data/ESSD Baker Creek Data/HydrometeorologicalData/landing tower half hourly time series v1.csv",col_names=colnames_landing, skip=1)
Landing_load$DateTime <- dmy_hm(Landing_load$DateTime)
head(Landing_load)

Oct1_TPND <- filter(Landing_load, !Twater==9999, month(DateTime)==10, day(DateTime)==1)
Oct1_TPND <- mean(Oct1_TPND$Twater)
head(Oct1_TPND)
