# This makefile runs the R scripts to convert the raw data into processed driving data for the Baker Creek MESH Model

objects1 = ../Data/Processed/Driving/Scenario1/basin_humidity.csv\
     ../Data/Processed/Driving/Scenario1/basin_longwave.csv\
     ../Data/Processed/Driving/Scenario1/basin_pres.csv\
		 ../Data/Processed/Driving/Scenario1/basin_rain.csv\
		 ../Data/Processed/Driving/Scenario1/basin_shortwave.csv\
		 ../Data/Processed/Driving/Scenario1/basin_temperature.csv\
		 ../Data/Processed/Driving/Scenario1/basin_wind.csv

objects2 = BakerCreekDataPrep.Rmd CombineAirP.R CombineKandLData.R\
     CombinePrecipData.R CombineSpecHumid.R CombineTempData.R CombineUData.R

# If the R scripts have changed, run the R scripts to generate the 7 forcing data files for the model (csv)

# Note: select one of the output files as the target; putting in a "dummy" target will run the makefile every time make is called, whether or not the prerequesite files have changed or not since the last run

$(objects1): $(objects2)
	./RunRmd.sh
	Rscript CombineAirP.R
	Rscript CombineKandLData.R
	Rscript CombinePrecipData.R
	Rscript CombineSpecHumid.R
	Rscript CombineTempData.R
	Rscript CombineUData.R
	echo "Driving Data Makefile Run: Success"
