#!/bin/bash

COUNTER=`qstat |wc`
echo $COUNTER
set -- $COUNTER
value=$1
shift
echo $value
while [  $value -gt 0 ]; do
    echo The number of jobs $value
    sleep 300
    COUNTER=`qstat |wc`
    set -- $COUNTER
    value=$1
    echo $value
done

cd /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/mincANTS-15jul10_long
for file in /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/invivo-15jul10_processed/*/resampled/*_final_linear.mnc; do base=`basename $file .mnc`; sge_batch -J mincresample-${base} mincresample $file ${base}_resampled.mnc -transform ${base}_mincANTS.xfm -like /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/invivo-15jul10_nlin/nlin-5.mnc; done

cd /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/mincANTS-15jul10
for file in /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/invivo-15jul10_processed/*/resampled/*_final_linear.mnc; do base=`basename $file .mnc`; sge_batch -J mincresample-${base} mincresample $file ${base}_resampled.mnc -transform ${base}_mincANTS.xfm -like /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/invivo-15jul10_nlin/nlin-5.mnc; done