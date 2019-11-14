#!/bin/bash

# INPUTS
trials=4
numfolders=2   #Number of folders to sub-divide the trials into (must be evenly divisible)
Scenario=1
templatefolder=Scenario1Template # Folder to copy model files from


# SCRIPT - CREATE SUB-FOLDERS, UPDATE THE SUBMITJOB.SH FILE
let Y=1
let subdiv=trials/numfolders
let remainder=trials%numfolders
echo $remainder
let Z=Y+subdiv-1

if (($remainder > 0))
then
  echo "Error: Please choose <numfolders> evenly divisible in <trials>"
  exit 1
else

for X in $(seq 1 $numfolders);
do

subfolder="Scenario${Scenario}_${X}"

if [[ ! -d ${subfolder} ]] ; then
  mkdir $subfolder
fi

cp -r $templatefolder/* $subfolder/

sed -i -e 's/job-name=Scenario1_1/job-name='$subfolder'/g' $subfolder/Input/submitjob.sh

Y2=$(printf "%03d" $Y)

Z2=$(printf "%03d" $Z)

sed -i -e 's/{001..010}/{'$Y2'..'$Z2'}/g' $subfolder/Input/submitjob.sh

let Y=Y+subdiv
let Z=Z+subdiv
done

for f in Scenario${Scenario}_*
do
  echo $f
  chmod +x ./$f/RunAll.sh
  ./$f/RunAll.sh
  # Note: This doesn't work when running on a Linux sub-system in Windows due to the symbolic links
done



fi
