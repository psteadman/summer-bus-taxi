#!/bin/bash

export PATH=/micehome/jlerch/linux-experimental/src/mincANTS_1p9:$PATH
export SGE_BATCH_OPTIONS='OS=hardy'
cd /projects/souris/jurgen/LearnAndMem/taxibus_apr2010_mincANTS

for file in /projects/souris/jurgen/LearnAndMem/taxibus_apr2010_processed/*/resampled/*_final_linear.mnc; do base=`basename $file .mnc`; sge_batch -J ants-${base} mincANTS 3 -m PR[$file,/projects/souris/jurgen/LearnAndMem/taxibus_apr2010_nlin/nlin-6.mnc,1,5] -t SyN[0.25] -r Gauss[3,1] -x /projects/mice/jlerch/binb-model-standard-orientation-2007/native-atlas_mask.mnc -i 80x70x20 -o ${base}_mincANTS.xfm; done
# 
# sge_batch -J mincresample-$file mincresample $file ${base}_resampled.mnc -transform ${base}_mincANTS.xfm -like /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/invivo-15jul10_nlin/nlin-5.mnc