#!/bin/bash
# Sample Slurm Script for use with OpenMPI on Plato
# Begin Slurm directives with #SBATCH

#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --mem=4G
#SBATCH --time=80:00:00
#SBATCH --job-name=Scenario1-P_1

echo "Starting run at: `date`"

# Loop of trials (e.g. random seeds)
#for trial in 001
for trial in {001..010}
do

# Run OstrichGCC

#srun ./OstrichGCC
# srun is for running in parallel
../../Ostrich/OstrichGCC

#Create an output folder for the trial
output_fname="../Output/ostOutput${trial}"

    #First, check if it exists from a previous run and if so, delete contents and folder and then create the new drive
rm -rf $output_fname

mkdir $output_fname

#Copy Ostrich output
cp OstModel0.txt OstOutput0.txt $output_fname/

#Copy MESH output
cp MESH_parameters_hydrology.ini MESH_parameters_CLASS.ini Basin_average_*.csv MESH_output_*.* Metrics_Out.txt $output_fname/

done

echo "Program finished with exit code $? at: `date`"
exit 0
