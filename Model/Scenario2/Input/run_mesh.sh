#!/bin/bash

# Remove existing output files (-f in case they don't exist)
rm -f BASINAVG1/* CLASSOUT/* abserr.txt drms.txt function_out.txt Metrics_Out.txt MonteCarlo.txt NS*.txt

# Create the BASINAVG1 folder if it doesn't exist
if [[ ! -f BASINAVG1 ]] ; then
  mkdir BASINAVG1
fi

# Run MESH
../../MESH_Code/MESH_Code.r1024/sa_mesh || true

# Create dummy Metrics_Out.txt if one doesn't exist (model has crashed)
if [[ ! -f Metrics_Out.txt ]] ; then
  echo '          Gauge             MAE            RMSE            BIAS         AbsBIAS             NSD          NegNSD           lnNSD        NeglnNSD ' >> Metrics_Out.txt
  echo '              1             999            999           999         999             -999          999             -999        999 ' >> Metrics_Out.txt
fi
