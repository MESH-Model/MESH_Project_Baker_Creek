#!/bin/bash

# This file executes pre-processing scripts and makefiles, runs MESH, and then runs post-processing scripts to generate outputs.

# 1. Obtain the directory where this script is located
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# 2. Process the driving data by running the "make" file in the "Code" folder, which calls all the Rscripts
cd $DIR
cd ../../Code
make

# 3. Run the makefile to update the CLASS.ini and hydrology.ini files based on the "ParamValues.csv" file, and copy the files to the "Model/Scenario_X/Input" folder
# cd $DIR
# cd ../../Code
# Rscript Find_Replace_in_Text_File.R
# cp MESH_parameters_CLASS.ini MESH_parameters_CLASS.tpl MESH_parameters_hydrology.ini MESH_parameters_hydrology.tpl $DIR/Input

# 4. Create symbolic links to the driving data
cd $DIR/Input
pwd
    # a) Use this chunk if using Mac or Linux
# ln -sf ../../../Data/Processed/Driving/Scenario2and3/basin_humidity.csv ./basin_humidity.csv
# ln -sf ../../../Data/Processed/Driving/Scenario2and3/basin_longwave.csv ./basin_longwave.csv
# ln -sf ../../../Data/Processed/Driving/Scenario2and3/basin_pres.csv ./basin_pres.csv
# ln -sf ../../../Data/Processed/Driving/Scenario2and3/basin_rain.csv ./basin_rain.csv
# ln -sf ../../../Data/Processed/Driving/Scenario2and3/basin_shortwave.csv ./basin_shortwave.csv
# ln -sf ../../../Data/Processed/Driving/Scenario2and3/basin_temperature.csv ./basin_temperature.csv
# ln -sf ../../../Data/Processed/Driving/Scenario2and3/basin_wind.csv ./basin_wind.csv

    # b) Or use this chunk for Linux sub-system on windows (note: file links have same size as original)
ln -Pf ../../../Data/Processed/Driving/Scenario2and3/basin_humidity.csv ./basin_humidity.csv
ln -Pf ../../../Data/Processed/Driving/Scenario2and3/basin_longwave.csv ./basin_longwave.csv
ln -Pf ../../../Data/Processed/Driving/Scenario2and3/basin_pres.csv ./basin_pres.csv
ln -Pf ../../../Data/Processed/Driving/Scenario2and3/basin_rain.csv ./basin_rain.csv
ln -Pf ../../../Data/Processed/Driving/Scenario2and3/basin_shortwave.csv ./basin_shortwave.csv
ln -Pf ../../../Data/Processed/Driving/Scenario2and3/basin_temperature.csv ./basin_temperature.csv
ln -Pf ../../../Data/Processed/Driving/Scenario2and3/basin_wind.csv ./basin_wind.csv

# and change the executable file permissions
chmod +x run_mesh.sh submitjob.sh

# 5. Check if mesh is compiled, and if not, compile with "make"
cd $DIR

# a)
cd ../MESH_Code/MESH_Code.r1024
if [[ ! -x sa_mesh ]] ; then # If sa_mesh is not found or not executable
  make -f makefile.gfortran
fi

# b)
cd $DIR
cd ../Ostrich
if [[ ! -x OstrichGCC ]] ; then # If OstrichGCC is not found or not executable
  make GCC
fi

# 6. Run MESH
cd $DIR/Input

  # a)
# ./run_mesh.sh

  # b)
# ./submitjob.sh

  # c)
sbatch submitjob.sh

# 7. Run the post-processing script and generate ONE jpeg to start
### INCOMPLETE
