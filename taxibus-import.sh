#!/bin/bash


for file in /media/LaCie/Exported_Data/busmice_14jun10/*.txt; do base=`basename $file `; 
		if [ "${base}" == "Analysis Output-busmice_*_*(1).txt" ]; then
			cp $file busmice/mouse.b52/
			continue
		elif [ "${base}" == "Analysis Output-busmice_*_*(2).txt" ]; then 
			cp $file busmice/mouse.b51/
			continue 
		elif [ "${base}" == "Analysis Output-busmice_*_*(3).txt" ]; then
			cp $file busmice/mouse.b48/
			continue
		fi
		done 


