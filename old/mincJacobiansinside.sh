#!/bin/bash

file=$1
base=$2

echo smooth_vector --filter --fwhm=0.2 $file ${base}_smoothvector.mnc;
smooth_vector --filter --fwhm=0.2 $file ${base}_smoothvector.mnc;
echo mincblob -determinant ${base}_smoothvector.mnc ${base}_blob.mnc;
mincblob -determinant ${base}_smoothvector.mnc ${base}_blob.mnc;
echo mincmath -const 1 -add ${base}_blob.mnc ${base}_1math.mnc;
mincmath -const 1 -add ${base}_blob.mnc ${base}_1math.mnc;
echo mincmath -log ${base}_1math.mnc ${base}-log-determinant-fwhm0.2.mnc;
mincmath -log ${base}_1math.mnc ${base}-log-determinant-fwhm0.2.mnc;
echo sge_batch -J jacobians-${base} mincconvert -2 $file ${base}.2.mnc
sge_batch -J jacobians-${base} mincconvert -2 ${base}-log-determinant-fwhm0.2.mnc ${base}-log-determinant-fwhm0.2.2.mnc