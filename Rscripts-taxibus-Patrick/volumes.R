############ Program: Compute brain volume change
# normalized to day 0 image and brain volume

############ Start up ############
# set working directory
initial.wd3 <- getwd()
setwd("/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/taxibus-analysis")

# load the necessary libraries
library(ggplot2)
library(RMINC)
# remove current workspace
# rm(list = ls())


########## Load and organize the data ########
#specify data to look at
DATE <- readline(prompt = "Enter date of specific pipeline(ie: 1jul10) ")
df <- paste("/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/taxibus-analysis/csv-files/image-mouse-day-spreadsheet-",DATE,".csv",sep="")
gfl <- read.csv(df)
#make minc files full path
gfl$bname <- sub('.mnc','',gfl$Image)
gfl$jacobians <- 0 #jacobians with a fwhm of 0.5 used for voxel analysis
for (i in 1:nrow(gfl)) {
gfl$jacobians[i] <- system(paste("ls ", "/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/invivo-", DATE, "_processed/", gfl$bname[i], "/stats-volumes/", gfl$bname[i], "-log-determinant-fwhm0.5.mnc", sep=""), intern=T)
}
#creates jacobian variable for those with fwhm 0.1 - used for structure analysis
gfl$smalljacobians <- sub('log-determinant-fwhm0.5.mnc', 'log-determinant-scaled-fwhm0.1.mnc', gfl$jacobians)
# Acquire volumes in cubed mm (structure separated by right and left)
anat.atlas <- paste("/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/atlas-transform/atlas-",DATE,"-nlin5.mnc",sep="")
#allvols <- anatGetAll(gfl$smalljacobians, "../atlas-transform/1jul10-nlin5atlas.mnc")
allvols <- anatGetAll(gfl$smalljacobians, anat.atlas)
# combined volumes (not separated by right and left)
vols <- anatCombineStructures(allvols)
# acquire whole brain volume for each image
brainVolume <- rowSums(vols)

NormalizedVolume <- mat.or.vec(nrow(gfl),ncol(vols))
for (w in 1:ncol(vols)){
	for (i in 1:nrow(gfl)) {
	NormalizedVolume[i,w] <- vols[i,w] - vols[gfl$Mouse.. == gfl$Mouse..[i] & gfl$Day == 0, w]}}
colnames(NormalizedVolume) <- colnames(vols)
