# MESH Baker Creek Processing Code
This folder contains the code used to do the pre-processing of the driving and streamflow data, and the post-processing and visualization. Brief descriptions of each file are provided below.

## Pre-processing
The driving data for the model was generated from combination of on-site observations (as published in the ESSD paper by Spence and Hedstrom, 2018, ECCC station Yellowknife A, and GEM/CaPA data.

- Download_Write_Weather_Data.R
  - Used to download and write a .Rda file for the Yellowknife A data
- BakerCreekDataPrep.Rmd
  - Used to put the data from all sources into data frames with a consistent format (i.e. same number and names of columns, some unit conversions)
- Combine*.R
    - Used to combine the data from all sources into one driving data file for each of the 7 variables required for MESH
- StreamflowPrep.Rmd
    - Used to prepare streamflow data for the model
    - Creates 3 copies: one for calibration (i.e. sets NA values for the model period not used in the calibration), one for validation, and one for the whole model period
  - SoilTempMoisture.R
    - Used to analyze and summarise the soil temperature and moisture data for use in initializing the model.
  - MESHOutput.Rmd
    - A R Markdown notebook to load, process, and visualize the model outputs for the project report.
