#!/bin/bash

file=$1
base=$2
echo 'file is ' $file
echo 'base is ' $base

# image registration of each final linear registration to nlin-5 average using mincANTS (long settings)
echo mincANTS 3 -m PR[$file,/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/invivo-04oct10_nlin/nlin-5.mnc,1,5] -t SyN[0.25] -r Gauss[3,1] -x /projects/souris/psteadman/in-vivo-buildmodel/manual-transform/make-init-model/native-model-atlas_mask.mnc -i 80x70x20 -o ${base}_mincANTS.xfm
mincANTS 3 -m PR[$file,/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/invivo-04oct10_nlin/nlin-5.mnc,1,5] -t SyN[0.25] -r Gauss[3,1] -x /projects/souris/psteadman/in-vivo-buildmodel/manual-transform/make-init-model/native-model-atlas_mask.mnc -i 80x70x20 -o ${base}_mincANTS.xfm
# resampling of the files with the created transforms
echo mincresample $file ${base}_resampled.mnc -transform ${base}_mincANTS.xfm -like /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/invivo-04oct10_nlin/nlin-5.mnc
mincresample $file ${base}_resampled.mnc -transform ${base}_mincANTS.xfm -like /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/invivo-04oct10_nlin/nlin-5.mnc
# creating the determinant of the 0.2 blurred jacobians of the non-linear transformation component of the mincANTS registration
echo smooth_vector --filter --fwhm=0.2 ${base}_mincANTS_inverse_grid_0.mnc ${base}_smoothvector.mnc;
smooth_vector --filter --fwhm=0.2 ${base}_mincANTS_inverse_grid_0.mnc ${base}_smoothvector.mnc;
echo mincblob -determinant ${base}_smoothvector.mnc ${base}_blob.mnc;
mincblob -determinant ${base}_smoothvector.mnc ${base}_blob.mnc;
echo mincmath -const 1 -add ${base}_blob.mnc ${base}_1math.mnc;
mincmath -const 1 -add ${base}_blob.mnc ${base}_1math.mnc;
echo mincmath -log ${base}_1math.mnc ${base}-log-determinant-fwhm0.2.mnc;
mincmath -log ${base}_1math.mnc ${base}-log-determinant-fwhm0.2.mnc;
echo mincconvert -2 ${base}-log-determinant-fwhm0.2.mnc ${base}-log-determinant-fwhm0.2.2.mnc
mincconvert -2 ${base}-log-determinant-fwhm0.2.mnc ${base}-log-determinant-fwhm0.2.2.mnc
echo mv ${base}-log-determinant-fwhm0.2.2.mnc ${base}-log-determinant-fwhm0.2.mnc
mv ${base}-log-determinant-fwhm0.2.2.mnc ${base}-log-determinant-fwhm0.2.mnc
