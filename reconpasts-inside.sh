#!/bin/bash
 
file=$1
imgdate=$2
dire=$3

echo cd /projects/souris/psteadman/MRdata/reconstructed-fids/${dire}
cd /projects/souris/psteadman/MRdata/reconstructed-fids/${dire}
pwd
echo export FIDDIR="'.'"
export FIDDIR="'.'"
echo export IMGDIR="."
export IMGDIR="."
#echo vrecon -vmap fse_192_192_8_3 -shift -dc -scalefft fid img_${imgdate}
#vrecon -vmap fse_192_192_8_3 -shift -dc -scalefft fid img_${imgdate}

echo vrecon -vmap /projects/souris/psteadman/MRdata/vmap/fsetable_feather_336_168_12_4 -shiftppe -dc -scalefft -croplpe $file img_${imgdate}
vrecon -vmap /projects/souris/psteadman/MRdata/vmap/fsetable_feather_336_168_12_4 -shiftppe -dc -scalefft -croplpe fid img_${imgdate}

echo cp img* /projects/souris/jurgen/LearnAndMem/live_imaging/native/
cp img* /projects/souris/jurgen/LearnAndMem/live_imaging/native/