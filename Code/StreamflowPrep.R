#The purpose of this script is to prepare the streamflow observations for the MESH model for the Baker Creek watershed in the NWT

##### Load Libraries
library(tidyverse)
library(dplyr)
library(lubridate)
library(MESHr)

##### Load in the data
Qload <- read_csv(file="F:/ECCC_Project/MESH Model/Baker Creek Model Files/Scenario1_2/ostOutput{001}/MESH_output_streamflow.csv")

    # Param=1: Daily Discharge, Param=2: Daily Water Level
    # Symbols: E=Estimate, A=PartialDay, B=Ice Conditions, D=Dry, R=Revised

Q <- Qload
Q <- Q %>%
  filter(PARAM==1 & Date>="2004-10-01") %>% 
  select(-ID, -PARAM)
    # Choose the start date of the streamflow to correspond to 1 year before the model start date
    # Streamflow only available until 2016

#Replace missing values with -ve number
Q$Value[is.na(Q$Value)==TRUE] <- -9999

#Plot the streamflow
QPlot <- Q
QPlot$Value[QPlot$Value==-9999] <- NA

QPlot$CommonDate <- as.Date(paste0("2000-", format(QPlot$Date, "%j")),"%Y-%j")
ggplot() + 
  geom_line(data=QPlot, mapping=aes(x=CommonDate, y=Value)) + 
  facet_grid(year(QPlot$Date) ~ .) + 
  scale_x_date(labels=function(x) format(x,"%d-%b"))

ggplot(data=QPlot, mapping=aes(x=Date))+
  geom_line(aes(y=Value)) +
  scale_x_date(date_labels=("%Y"), date_breaks=("years"))

Q_05_11 <- filter(QPlot, year(Date) %in% 2005:2011)
ggplot() + 
  geom_line(data=Q_05_11, mapping=aes(x=CommonDate, y=Value)) + 
  facet_grid(year(Q_05_11$Date) ~ .) + 
  scale_x_date(labels=function(x) format(x,"%d-%b"))

Q_12_18 <- filter(QPlot, year(Date) %in% 2012:2018)
ggplot() + 
  geom_line(data=Q_12_18, mapping=aes(x=CommonDate, y=Value)) + 
  facet_grid(year(Q_12_18$Date) ~ .) + 
  scale_x_date(labels=function(x) format(x,"%d-%b"))

##### Write the streamflow to files
setwd("C:/Users/haley/OneDrive/Documents/1.MWS2018-2019/T2/Project/ECCC_Project/R Code/")
QFinal <- select(Q, Date, Value)
QWrite <- select(Q, Value)
write_excel_csv(QFinal, "../MESH Model/Baker Creek Model Files/Streamflow_full.xlsx.csv")
write_tsv(QWrite, "../MESH Model/Baker Creek Model Files/Streamflow.csv", col_names=FALSE)

##### Determine the start date of the model
### Want: no snow on the ground, no ponding on the ground or canopy (i.e. no recent rain events), and no frozen water in the soil

