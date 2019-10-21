#!/bin/bash

# Remove existing output files (-f in case they don't exist)
rm -f abserr.txt drms.txt function_out.txt Metrics_Out.txt MonteCarlo.txt NS*.txt Basin_average_*.csv MESH_output_*.txt
# BASINAVG1/* CLASSOUT/*

# Run MESH
#/home/hlb749/RunMesh/MESH_Code.r1024/sa_mesh || true
/home/hlb749/RunMesh/r1552_mod/sa_mesh || true

# Create dummy Metrics_Out.txt if one doesn't exist (model has crashed)
if [[ ! -f Metrics_Out.txt ]] ; then
  echo '          Gauge             MAE            RMSE            BIAS         AbsBIAS             NSD          NegNSD           lnNSD        NeglnNSD ' >> Metrics_Out.txt
  echo '              1             999            999           999         999             -999          999             -999        999 ' >> Metrics_Out.txt
fi
