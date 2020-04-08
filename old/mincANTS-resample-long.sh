#!/bin/bash

export PATH=/micehome/jlerch/linux-experimental/src/mincANTS_1p9:$PATH
export SGE_BATCH_OPTIONS='OS=hardy'
cd /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase
cd mincANTS-15jul10_long
for file in /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/invivo-15jul10_processed/*/resampled/*_final_linear.mnc; do base=`basename $file .mnc`;
sge_batch -J ants-${base} mincANTS 3 -m PR[$file,/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/invivo-15jul10_nlin/nlin-5.mnc,1,5] -t SyN[0.25] -r Gauss[2,0.5] -x /projects/souris/psteadman/in-vivo-buildmodel/manual-transform/make-init-model/native-model-atlas_mask.mnc -i 100x80x70x40 -o ${base}_mincANTS.xfm; done
# sge_batch -J mincresample-$file mincresample $file ${base}_resampled.mnc -transform ${base}_mincANTS.xfm -like /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/invivo-15jul10_nlin/nlin-5.mnc