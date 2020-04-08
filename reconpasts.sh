#!/bin/bash

#export SGE_BATCH_OPTIONS='OS=hardy'
cd /projects/souris/psteadman/MRdata/reconstructed-fids/
#for file in fse3dmice*.fid/fid; do dire=`dirname $file`; dirbase=`basename $dire .fid`; imgdate=`echo $dirbase | cut -c16-`; sge_batch -J recon-${dirbase} reconpasts-inside.sh $file $imgdate $dire; done

for file in t2w3dfse_livemice*.fid/fid; do dire=`dirname $file`; dirbase=`basename $dire .fid`; imgdate=`echo $dirbase | cut -c24-` 
echo cd /projects/souris/psteadman/MRdata/reconstructed-fids/${dire}
cd /projects/souris/psteadman/MRdata/reconstructed-fids/${dire}
pwd
echo export FIDDIR='"."'
export FIDDIR='"."'
echo export IMGDIR='"."'
export IMGDIR='"."'
#echo vrecon -vmap fse_192_192_8_3 -shift -dc -scalefft fid img_${imgdate}
#vrecon -vmap fse_192_192_8_3 -shift -dc -scalefft fid img_${imgdate}

echo vrecon -vmap /projects/souris/psteadman/MRdata/vmap/fsetable_feather_336_168_12_4 -shiftppe2 -dc -scalefft -croplpe -p /projects/souris/psteadman/MRdata/reconstructed-fids/${dire}/procpar fid img_${imgdate} -clobber -verbose >> /home/psteadman/Desktop/output.txt
#vrecon -vmap /projects/souris/psteadman/MRdata/vmap/fsetable_feather_336_168_12_4 -shiftppe2 -dc -scalefft -croplpe -p /projects/souris/psteadman/MRdata/reconstructed-fids/${dire}/procpar fid img_${imgdate} -clobber -verbose 

echo cp img* /projects/souris/jurgen/LearnAndMem/live_imaging/native/
cp img* /projects/souris/jurgen/LearnAndMem/live_imaging/native/
echo 
echo 
done


#reconpasts-inside.sh $file $imgdate $dire; done