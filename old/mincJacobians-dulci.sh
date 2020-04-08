#!/bin/bash


cd /projects/souris/jurgen/LearnAndMem/taxibus_apr2010_mincANTS
for file in /projects/souris/jurgen/LearnAndMem/taxibus_apr2010_mincANTS/taxibus*final_linear_mincANTS_inverse_grid_0.mnc; do 
base=`basename $file .mnc`; 
sge_batch -J jacobians-$base mincJacobiansinside.sh $file $base; 
done
