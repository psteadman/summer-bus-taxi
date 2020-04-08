#!/bin/bash
#taxibus-import.sh

# Script replaces whitespace in exported filenames with underscore and then copies files to directories
FOUND=0 

echo -n "Enter export directory: "
read -e EXPORTDIR
echo -n "Enter first mouse directory: "
read -e BUS1DIR
echo -n "Enter second mouse directory: "
read -e BUS2DIR
echo -n "Enter third mouse directory: "
read -e BUS3DIR

for filename in $EXPORTDIR/*       #Traverse all files in directory.
do
     echo "$filename" | grep -q " "         #  Check whether filename
     if [ $? -eq $FOUND ]                   #+ contains space(s).
     then
       fname=$filename                      
       n=`echo $fname | sed -e "s/ /_/g"`   # Substitute underscore for blank.
       mv "$fname" "$n"                     # Do the actual renaming.
     fi
done   

for file in $EXPORTDIR/*;
	do base=`basename "$file"`; 
	number=`echo "$file" | perl -npe 's/.+(\d)\).txt/$1/'`; 
	if [ "${number}" == 1 ]; 
		then cp $file $BUS1DIR/$base ; 
	elif [ "${number}" == 2 ]; 
		then cp $file $BUS2DIR/$base ; 
	elif ["${number}" == 3 ]; 
		then cp $file $BUS3DIR/$base; 
	fi; 
done