########################################################
############ Main Program: Taxibus Analysis ############
########################################################

# load the necessary libraries
library(ggplot2)
library(RMINC)
# remove current workspace
# rm(list = ls())

########### Some Functions ##################################

# mouse <- the mouse variable in which you want to plot the metric data
# metric <- the metric variable or column # you are interested in plotting
plotbehaviourlm<-function(mouse,metric){
	if (is.numeric(metric) == TRUE) {
		aa<-names(mouse[metric])
		print(qplot(mouse$Trial,mouse[,metric],geom=c("point","smooth"),data=mouse,method="lm",ylab=aa, xlab="Trails per Day") + facet_grid(.~Day))
		#qplot(mouse$Trial,mouse[,metric],geom=c("point","smooth"),data=mouse,method="lm",ylab=aa, xlab="Trails per Day") + facet_grid(.~Day)
		answer<-readline(prompt="Do you want to save this plot? ")
		if (answer == "yes" || answer == "y") {
			filename<-paste(mouse,aa,"plot.pdf",sep="_")
			dev.copy(device=pdf, filename)
			dev.off()
			}
		else {print("Plot not saved")}
		}
	else{
		print("metric condition must be column # corresponding to metric of interest")
		#qplot(mouse$Trial,metric,geom=c("point","smooth"),data=mouse,method="lm") + facet_grid(.~Day)
		}
	}
	

# glmfile <- the general linear model file with image information, include the image path, mouse, and Day corresponding to each image.	
# volume <- volume file of interest in which you wish to normalize to day 0, usually created using 'anatGetAll' if for structures and 'mincGetVoxel' if for voxels.
# outputname <- the variable's name to be created with this function
normvols<-function(glmfile,volume,outputname){
	outputname <- mat.or.vec(nrow(glmfile),ncol(volume))
	for (w in 1:ncol(volume)){
		for (i in 1:nrow(glmfile)){
			outputname[i,w] <- volume[i,w] - volume[glmfile$Mouse.. == glmfile$Mouse..[i] & glmfile$Day == 0, w]
			}
		}
	}


############ Sub Program: Import Bus data ############

#set working directory
initial.wd1=getwd()
setwd("/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/taxibus-analysis/behavioural-data/busmice")
#create list of files to be imported
busmicefiles<-list.files(pattern="^[mouse]")
#columns within files to be imported and final variables created here
header.names<-c("TotalTrial","Mouse","Day","Trial","Distance.moved.cm.total","Distance.to.target.cm.mean","Distance.to.target.cm.total","Heading.mean.centre.pt","Velocity.cm.s.mean","Duration.in.any.nontarget.s","Freq.in.any.nontarget","Latency.head.directed.to.target.s","Latency.to.target.s")
#importing and creating a variable for each mouse based on the name of the folder containing the files for that mouse (currently: each file is 1 trial; thus the rbind command because 1 trial = 1 row)
for (folder in busmicefiles){
	mouse.nam<-folder
	tempfiles<-list.files(folder)
	DF<-NULL
	for (f in tempfiles){
		dat<-read.table(paste(folder,f,sep="/"), skip=4,sep=",",header=F)
		dat[,13]<-as.numeric(as.character(dat[,13]))
		dat[,14]<-NULL
		DF<-rbind(DF,dat)
		}
	colnames(DF)<-header.names
	DF<-replace(DF[,13],in.na(DF[,13]),180)
	assign(mouse.nam,DF,envir=.GlobalEnv)
	}

############ Sub Program: Import Taxi Data ############

#set working directory
initial.wd2=getwd()
setwd("/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/taxibus-analysis/behavioural-data/taximice")
#create list of files to be imported
taximicefiles<-list.files(pattern= "^[mouse]" )
#columns within files to be imported and final variables created here
header.names<-c("ignore","Mouse","Day","Trial","Distance.moved.cm.total","Distance.to.target.cm.mean","Distance.to.target.cm.total","Heading.mean.centre.pt","Velocity.cm.s.mean","Duration.in.any.nontarget.s","Freq.in.any.nontarget","Latency.head.directed.to.target.s","Latency.to.target.s")
#importing and creating a variable for each mouse based on the name of the imported file
for (folder in taximicefiles){
	mouse.nam<-folder
	mouse.nam<-sub('.csv','',mouse.nam)
	DF<-NULL
	DF<-read.table(folder, skip=4,sep=",",header=F)
	DF[,13]<-as.numeric(as.character(DF[,13]))
	colnames(DF)<-header.names
	DF<-replace(DF[,13],in.na(DF[,13]),180)
	assign(mouse.nam,DF,envir=.GlobalEnv)
	}


############ Sub Program: Compute brain volume change ############
# Function: normalized to day 0 image and brain volume

# set working directory
initial.wd3 <- getwd()
setwd("/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/taxibus-analysis")

########## Load and organize the data
#specify data to look at
DATE <- readline(prompt = "Enter date of specific pipeline(ie: 1jul10) ")
df <- paste("/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/taxibus-analysis/csv-files/image-mouse-day-spreadsheet-",DATE,".csv",sep="")
gfl <- read.csv(df)
#make minc files full path
gfl$bname <- sub('.mnc','',gfl$Image)
gfl$jacobians <- 0 #jacobians with a fwhm of 0.5 used for VOXEL analysis

for (i in 1:nrow(gfl)) {
	gfl$jacobians[i] <- system(paste("ls ", "/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/invivo-", DATE, "_processed/", gfl$bname[i], "/stats-volumes/", gfl$bname[i], "-log-determinant-fwhm0.5.mnc", sep=""), intern=T)
	}
#creates jacobian variable for those with fwhm 0.1 - used for STRUCTURE analysis
gfl$smalljacobians <- sub('log-determinant-fwhm0.5.mnc', 'log-determinant-scaled-fwhm0.1.mnc', gfl$jacobians)

# Acquire volumes in cubed mm (structure separated by right and left)
anat.atlas <- paste("/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/atlas-transform/atlas-",DATE,"-nlin5.mnc",sep="")
allvols <- anatGetAll(gfl$smalljacobians, anat.atlas)
# combined volumes (not separated by right and left)
vols <- anatCombineStructures(allvols)
# acquire whole brain volume for each image
brainVolume <- rowSums(vols)

NormalizedVolume <- mat.or.vec(nrow(gfl),ncol(vols))
for (w in 1:ncol(vols)){
	for (i in 1:nrow(gfl)){
		NormalizedVolume[i,w] <- vols[i,w] - vols[gfl$Mouse.. == gfl$Mouse..[i] & gfl$Day == 0, w]
		}
	}
colnames(NormalizedVolume) <- colnames(vols)
