#!/bin/bash

cd /projects/souris/jurgen/LearnAndMem/taxibus_apr2010_mincANTS
for file in /projects/souris/jurgen/LearnAndMem/taxibus_apr2010_processed/*/resampled/*_final_linear.mnc; do base=`basename $file .mnc`; sge_batch -J mincresample-${base} mincresample $file ${base}_resampled.mnc -transform ${base}_mincANTS.xfm -like /projects/souris/jurgen/LearnAndMem/taxibus_apr2010_nlin/nlin-6.mnc; 
done