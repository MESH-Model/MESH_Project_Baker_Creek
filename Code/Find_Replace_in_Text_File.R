#This script reads the MESH_parameters_CLASS and MESH_parameters_hydrology Ostrich template files into R, then does a "find-replace" using a .csv file containing the best parameter set from the calibration run and creates new .ini files
#
#Set the working directory to the location of the files 
setwd('F:/ECCC_Project/MESH Model/Baker Creek Model Files/Scenario3')

#Load libraries
library(tidyverse)
library(dplyr)

#Create a tibble of the parameter ranges, column 1 = parameters, column 2 = initial values
best_pars <- read_csv('Param_ranges.csv', col_names=FALSE)# header=c("Parameter", "Initial", "Min", "Max"))
#best_pars$Value <- as.character(best_pars$Value)
#best_pars[[10,2]]
head(best_pars)

#Read the Ostrich template files into R
class_pars  <- readLines("MESH_parameters_CLASS.tpl")
hydro_pars <- readLines("MESH_parameters_hydrology.tpl")
head(class_pars)

class_pars2 <- class_pars
hydro_pars2 <- hydro_pars
i <- 1
while(i<=nrow(best_pars)) {
  class_pars2  <- gsub(best_pars[[i,1]], best_pars[[i,2]], class_pars2)
  hydro_pars2  <- gsub(best_pars[[i,1]], best_pars[[i,2]], hydro_pars2)
  i <- i+1
}

writeLines(class_pars2, con="MESH_parameters_CLASS.ini")
writeLines(hydro_pars2, con="MESH_parameters_hydrology.ini")
