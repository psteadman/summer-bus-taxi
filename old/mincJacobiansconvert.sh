#!/bin/bash
 
cd /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/mincANTS-15jul10
for file in /projects/souris/jurgen/LearnAndMem/taxibus_apr2010_mincANTS/taxibus*_mincANTS_inverse_grid_0-log-determinant-fwhm0.2.mnc; do base=`basename $file .mnc`; sge_batch -J jacobians-${base} mincconvert -2 $file ${base}.2.mnc; done