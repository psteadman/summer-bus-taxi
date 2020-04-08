#!/bin/bash

export PATH=/micehome/jlerch/linux-experimental/src/mincANTS_1p9:$PATH
export SGE_BATCH_OPTIONS='OS=hardy'
cd /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase
#mkdir mincANTS-15jul10
cd mincANTS-15jul10
for file in /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/invivo-15jul10_processed/*/resampled/*_final_linear.mnc; do base=`basename $file .mnc`; sge_batch -J ants-${base} mincANTS 3 -m PR[$file,/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/invivo-15jul10_nlin/nlin-5.mnc,1,5] -t SyN[0.25] -r Gauss[3,1] -x /projects/souris/psteadman/in-vivo-buildmodel/manual-transform/make-init-model/native-model-atlas_mask.mnc -i 80x70x20 -o ${base}_mincANTS.xfm; done