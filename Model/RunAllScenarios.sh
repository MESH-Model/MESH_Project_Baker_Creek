#!/bin/bash

# INPUTS

Scenarios='1 2 3 1-P 2-P'

# Run MESH for each scenario
for S in $Scenarios
do
  echo $S
  folder="Scenario${S}"
  chmod +x ./$folder/RunAll.sh
  ./$folder/RunAll.sh
  # Note: This doesn't work when running on a Linux sub-system in Windows due to the symbolic links
done
