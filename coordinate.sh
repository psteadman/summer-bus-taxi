#!/bin/bash

# this script will convert all mnc files in the given directory to the new coordinate system. Be aware that all files under the paths do not require the same conversion and utilizing mincinfo before running this script on the file to confirm the correct changes is advised.
#Current Paths: /projects/souris/jurgen/LearnAndMem/live_imaging/native/
#This path doesn't need to be changed as it has already been modified
#Current Paths: /projects/souris/psteadman/in-vivo-buildmodel/manual-transform/make-init-model/
file=$1

for file; do
echo $file 
mincinfo $file
echo # new line
startx=`mincinfo -attval xspace:start $file`;
starty=`mincinfo -attval yspace:start $file`;
startz=`mincinfo -attval zspace:start $file`;
stepx=`mincinfo -attval xspace:step $file`;
stepy=`mincinfo -attval yspace:step $file`;
stepz=`mincinfo -attval zspace:step $file`;
lengthx=`mincinfo -dimlength xspace $file`;
lengthy=`mincinfo -dimlength yspace $file`;
lengthz=`mincinfo -dimlength zspace $file`;
calc1x=`echo ${lengthx}*${stepx} | bc`;
calc1y=`echo ${lengthy}*${stepy} | bc`;
calc1z=`echo ${lengthz}*${stepz} | bc`;
echo "Original Starting points of ${file}"
echo $startx , $starty , $startz;
echo "Change in Starting points"
echo $calc1x , $calc1y , $calc1z;
calcx=`echo $startx - $calc1x | bc`;
calcy=`echo $starty - $calc1y | bc`;
calcz=`echo $startz - $calc1z | bc`;
echo "New Starting points of ${file}"
echo $calcx , $calcy , $calcz ;
echo # new line
calcxx=`echo -1*$stepx  | bc`;
calcyy=`echo -1*$stepy | bc`;
calczz=`echo -1*$stepz | bc`;
echo minc_modify_header -dinsert xspace:step=$calcxx -dinsert yspace:step=$calcyy -dinsert zspace:step=$calczz $file;
minc_modify_header -dinsert xspace:step=$calcxx -dinsert yspace:step=$calcyy -dinsert zspace:step=$calczz $file;
echo minc_modify_header -dinsert xspace:start=$calcx -dinsert yspace:start=$calcy -dinsert zspace:start=$calcz $file; 
minc_modify_header -dinsert xspace:start=$calcx -dinsert yspace:start=$calcy -dinsert zspace:start=$calcz $file; 
echo # new line
mincinfo $file
echo # new line
done
