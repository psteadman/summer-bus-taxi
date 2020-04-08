#!/bin/bash


COUNTER=`qstat |wc`
#echo $COUNTER
set -- $COUNTER
value=$1
shift
#echo $value
while [  $value -gt 0 ]; do
    echo The number of jobs $value
    sleep 300
    COUNTER=`qstat |wc`
    set -- $COUNTER
    value=$1
    echo $value
done


export PATH=/micehome/jlerch/linux-experimental/src/mincANTS_1p9:$PATH
export SGE_BATCH_OPTIONS='OS=hardy'
cd /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/mincANTS-01nov10
for file in /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/invivo-01nov10_processed/*/resampled/*_final_linear.mnc; do base=`basename $file .mnc`; sge_batch -J ANTS-reg-${base} mincANTS-inside.sh $file $base; done

cd /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/atlas-transform/

#sge_batch -J mdl-to-nlin5 
mincANTS 3 -m PR[/projects/souris/psteadman/in-vivo-atlas/in-vivo-model.mnc,/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/invivo-01nov10_nlin/nlin-5.mnc,1,5] -t SyN[0.25] -r Gauss[2,0.5] -i 100x80x70x20 -x /projects/souris/psteadman/model-registration-mincANTS/in-vivo-model-mask.mnc -o mdl-to-nlin5-01nov10.xfm

mincresample /projects/souris/psteadman/Atlas_in-vivo/atlas_in-vivo.mnc atlas-01nov10-nlin5.mnc -transform mdl-to-nlin5-01nov10.xfm -like /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/invivo-01nov10_nlin/nlin-5.mnc -keep_real_range -nearest_neighbour

mincconvert -2 atlas-01nov10-nlin5.mnc tmp.mnc

mv tmp.mnc atlas-01nov10-nlin5.mnc
