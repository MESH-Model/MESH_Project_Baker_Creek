# This makefile runs the "Find_Replace_in_Text_File.R" script to populate the CLASS.ini and hydrology.ini files for MESH
# Then it runs the MESH model
# Then it runs the "PlotMeshOutputs.Rmd" file to generate a simple plot of model outputs.

#SHELL := /bin/bash

#objects1 = ../../MESH_Code/r1552_mod/sa_mesh
#objects2 = MESH_parameters_CLASS.txt MESH_parameters_hydrology.txt\
					../../Justification/ParamValues.csv ../../../Code/Find_Replace_in_Text_File.R
objects1 = ../Data/Processed/Driving/basin_humidity.csv\
     ../Data/Processed/Driving/basin_longwave.csv\
     ../Data/Processed/Driving/basin_pres.csv\
		 ../Data/Processed/Driving/basin_rain.csv\
		 ../Data/Processed/Driving/basin_shortwave.csv\
		 ../Data/Processed/Driving/basin_temperature.csv\
		 ../Data/Processed/Driving/basin_wind.csv

objects2 = BakerCreekDataPrep.Rmd CombineAirP.R CombineKandLData.R\
     CombinePrecipData.R CombineSpecHumid.R CombineTempData.R CombineUData.R

#objects4 = MESH_drainage_database.r2c MESH_input_reservoir.txt\
					MESH_input_run_options.ini MESH_input_soil_levels.txt\
					MESH_input_streamflow.txt MESH_parameters_CLASS.ini\
					MESH_parameters_hydrology.ini

# If the parameters or template files have been modified ("objects 1"), run the R script to populate the CLASS.ini and hydrology.ini files
# Select one of the output files as the target; putting in a "dummy" target will run the makefile every time make is called, whether or not the prerequesite files have changed or not since the last run
#MESH_parameters_CLASS.ini: $(objects1)
#	Rscript Find_Replace_in_Text_File.R

#If any of the driving data or input files have been updated, run MESH
# Select one of the output files as the target; putting in a "dummy" target will run the makefile every time make is called, whether or not the prerequesite files have changed or not since the last run
#Basin_average_water_balance.csv: $(objects2)
#	./r1552_mod/sa_mesh

#../../MESH_Code/r1552_mod/sa_mesh:
#	../../MESH_Code/r1552_mod bash -c "make"

#your-target: $(eval SHELL:=/bin/bash)
#    @echo "here shell is $$0"

$(objects1): $(objects2)
	./RunRmd.sh
	Rscript CombineAirP.R
	Rscript CombineKandLData.R
	Rscript CombinePrecipData.R
	Rscript CombineSpecHumid.R
	Rscript CombineTempData.R
	Rscript CombineUData.R


#Later could add a check if the model has been compiled (i.e. if there is a sa_mesh file, or if it has been compiled on the current comp.)


#ANDREW'S EXAMPLE
#CFFHM.pdf: CFFHM.md figures/Cover.png
	#pandoc -t latex -o CFFHM.pdf CFFHM.md
	#open CFFHM.pdf

#figures/Cover.png: figures/Diffn.py
  #cd figures; python Diffn.py
