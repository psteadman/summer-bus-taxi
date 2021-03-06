########################################################
############ Main Program: Taxibus Analysis ############
########################################################

### Required libraries:
library(ggplot2)
library(RMINC)

### LIST OF FUNCTIONS

## plotbehaviourlm: -checked
#    Given a mouse variable and a metric name or column number, plots the metric vs. trials. If facetbyday is "TRUE", facets by day. Otherwise plots metric vs. 1:30 (for default 30 trials). Fits a linear model to the data.

## normvols
#    TODO: DOCUMENT AND EDIT TO BE PATH/USER INDEPENDENT
## busimport: -checked 
#    Given a directory containing folders for each mouse (each containing a csv file for an individual trial) and a list of headers corresponding to the statistics exported by Ethovision, busimport imports data from each csv file into R. 
## taxiimport: -checked
#    Given a directory containing csv files for each mouse anda  list of headers corresponding to the stats exported by Ethovision, taxiimport imports data from each csv file into R

## metrictable: -checked 

# Given a metric of interest (eg. Duration.in.nontarget.s), a group (taxi, mice, control), number of trials, and the span of days you want to look at, metrictable returns a table in which each row corresponds to a mouse and each column is the metric of interest from one trial of one day.

## mouse.meanerrors: -checked

# Given a mouse, returns the mean number of errors (non-target holes visited) per day.

## mouse.miderrors: -checked

# Given a mouse, returns the median number of errors per day

## add.errors.to.gfl: 

# Given the data frame, a mouse (eg. mouse.b37) and a mouse id (eg. "b37"), returns a new data frame with the mean and median errors per day for the given mouse.

## Modify mouse dataframe:

# Given a mouse, computes the median duration in non-target per day. It then computes the difference and distance from the median for each trial, adds this to the mouse data frame, and returns a new mouse data frame. 

## fit behaviour: -checked

# Given a mouse, fits a non-linear model (K*(TotalTrial^log2(b)) to the Duration in non-target per trial data and returns the nonlinear model.

## add behaviour to gfl:

# Given a data frame (glmfile containing all mouse info), a mouse, and a mouse id, adds the learning rate (beta), intercept (K), and predicated duration in non-target holes on the last day for that mouse to a new data frame and returns that data frame. 

#########################################################
### FUNCTIONS BEGIN:
#########################################################


### plotbehaviourlm(mouse,metric)

# mouse <- the mouse variable in which you want to plot the metric data
# metric <- the metric variable or column # you are interested in plotting
plotbehaviourlm<-function(mouse=mouse,metric=metric,facetbyday=TRUE){

        if (is.numeric(metric)==FALSE){
               metric<-which(colnames(mouse)==metric)
        }
          print(metric)

          aa<-names(mouse[metric])
          byday<-""
          if (facetbyday == TRUE){
               byday<-"byday"
               print(qplot(mouse$Trial,mouse[,metric],geom=c("point","smooth"),data=mouse,method="lm",ylab=aa, xlab="Trails per Day") + facet_grid(.~Day))
          }
          else{
               print(qplot(1:30,mouse[1:30,metric],geom=c("point","smooth"),data=mouse,method="lm",ylab=aa, xlab="Trails per Day"))
          }
          answer<-readline(prompt="Do you want to save this plot? ")
          if (answer == "yes" || answer == "y") {
               filename<-paste('mouse',mouse[1,2],aa,byday,"plot.pdf",sep="_")
               dev.copy(device=pdf, filename)
               dev.off()
               }
          else {print("Plot not saved")}


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


### Import Bus Mice:

# Arguments:
# busdir <- the directory containing the individual bus mouse FOLDERS
# headers <- a list of variable header names corresponding to the stats exported from Ethovision 
# (see below for default)
#
# Preconditions:
# 1. Folders are named "mouse*"
# 2. Each file in folder "mousei" corresponds to an individual trial
# 3. The statistics exported from Ethovision are: 
#    a)
#    b)  
# If the file/statistic naming is not consistent with these conditions, certain functions may need to be slightly modified
# NB: "Duration.in.nontarget.s" (1) includes time in the arena vs. "Duration.in.any.nontarget.holes.s" (2) includes *only* times mouse was in a non-target hole zone. Hence (2) << (1).

header.names<-c("ignore","Mouse","Day","Trial","Distance.moved.cm.total","Distance.to.target.cm.mean","Distance.to.target.cm.total","Heading.mean.centre.pt","Velocity.cm.s.mean","Duration.in.any.nontarget.hole.s","Freq.in.any.nontarget","Latency.head.directed.to.target.s","Duration.in.nontarget.s")

busimport <- function(busdir="/projects/souris/vousdend/LearningMem/busmice/",headers=header.names){
     setwd(busdir)
     busmicefiles<<-list.files(pattern="^[mouse]")
     for (folder in busmicefiles){
	mouse.nam<-paste("bus",folder,sep="")
	tempfiles<-list.files(folder)
	DF<-NULL
	for (f in tempfiles){
		dat<-read.table(paste(folder,f,sep="/"), skip=4,sep=",",header=F)
		dat[,13]<-as.numeric(as.character(dat[,13]))
		dat[,14]<-NULL
		DF<-rbind(DF,dat)
		}
	colnames(DF)<-header.names
        # replace "NA" values for duration in non-target with trial length = 180 s
	DF[,13]<-replace(DF[,13],is.na(DF[,13]),180)
        # Add "Condition"
	assign(mouse.nam,DF,envir=.GlobalEnv)
	}
}

### Import taxi mice:
# Arguments:
# taxidir <- the directory containing the individual taxi mouse FILES
# headers <- a list of variable header names corresponding to the stats exported from Ethovision (see above for default)
# 
# Preconditions
# 1. Files are named "mouse*" and correspond to data across all days/trials for one mosue
# 2. The stats from ethovision are:
#
taxiimport <- function(taxidir="/projects/souris/vousdend/LearningMem/taximice/",headers=header.names){
     setwd(taxidir)
     taxilist<<-list()
     taximicefiles<<-list.files(pattern= "^[mouse]" )
     print(taximicefiles)
     for (folder in taximicefiles){
	mouse.nam<-paste("taxi",folder,sep="")
	mouse.nam<-sub('.csv','',mouse.nam)
	DF<-NULL
	DF<-read.table(folder, skip=4,sep=",",header=F)
	DF[,13]<-as.numeric(as.character(DF[,13]))
	colnames(DF)<-header.names
	DF[,13]<-replace(DF[,13],is.na(DF[,13]),180)
	assign(mouse.nam,DF,envir=.GlobalEnv)
        taxilist[[mouse.nam]]<<-DF
     }
}


### Metric table:
# Given a metric of interest (eg. Duration.in.nontarget.s), a group (taxi, mice, control), number of trials, and the span of days you want to look at, metrictable returns a table in which each row corresponds to a mouse and each column is the metric of interest from one trial of one day.

# Arguments:
# metric - a column name or number
# group - which group you want to look at (taxi, bus, or control)
# trials - number of trials each day (default: 6)
# first - first day of training data (default: 1)
# last - last day of training  data (default: 5)

metrictable <- function(metric,group,first=1,last=5,trials=6){
     days<-(last-first+1)
     total.trials<-days*trials
     trial.num <- 1
     day.num <- first
     column.names<-NULL
     metric.table<-NULL
     row.names<-NULL

          myfiles<-NULL
          if (group == "taxi"){
               myfiles<-ls(pattern="taximouse*",envir=.GlobalEnv)
          }
          else if (group == "bus"){
               myfiles<-ls(pattern="busmouse*",envir=.GlobalEnv)
          }
          else if (group == "control"){
               myfiles<-ls(pattern="controlmouse*",envir=.GlobalEnv)
          }
          first.value<-((first-1)*trials)+1
          last.value<-last*trials

          if (is.numeric(metric)==FALSE){
               metric<-which(colnames(get(myfiles[1]))==metric)
          }
          
          for (f in myfiles){
#                print(get(f)[first.value,metric])
               metric.table <- rbind(metric.table,get(f)[first.value:last.value,metric])
               row.names <- c(row.names,f)
          }
          metricname<-names(get(f)[metric])
          for (i in 1:total.trials){
               column.names[i] <- paste(day.num,trial.num,metricname,sep="_")
               trial.num<-trial.num+1
               if (trial.num > trials){
                    trial.num <-1
                    day.num <- day.num+1
               }
          }

          colnames(metric.table)<-column.names
          rownames(metric.table)<-row.names
          return(metric.table)

}

### mouse errors:

mouse.meanerrors<-function(mouse){
     means<-tapply(mouse$Freq.in.any.nontarget,mouse$Day,mean)
     return(means)
}
mouse.miderrors<-function(mouse){
     mids<-tapply(mouse$Freq.in.any.nontarget,mouse$Day,median)
     return(mids)
}

### add errors to gfl

add.errors.to.gfl <- function(gfl,mouse,mouse.id){
     means<-mouse.meanerrors(mouse)
     mids<-mouse.miderrors(mouse)
     gfl$meanErrorsDay1[gfl$Mouse.. == mouse.id] <- means[1]
     gfl$meanErrorsDay2[gfl$Mouse.. == mouse.id] <- means[2]
     gfl$meanErrorsDay3[gfl$Mouse.. == mouse.id] <- means[3]
     gfl$meanErrorsDay4[gfl$Mouse.. == mouse.id] <- means[4]
     gfl$meanErrorsDay5[gfl$Mouse.. == mouse.id] <- means[5]
     gfl$midErrorsDay1[gfl$Mouse.. == mouse.id] <- mids[1]
     gfl$midErrorsDay2[gfl$Mouse.. == mouse.id] <- mids[2]
     gfl$midErrorsDay3[gfl$Mouse.. == mouse.id] <- mids[3]
     gfl$midErrorsDay4[gfl$Mouse.. == mouse.id] <- mids[4]
     gfl$midErrorsDay5[gfl$Mouse.. == mouse.id] <- mids[5]
     gfl$Improvement[gfl$Mouse.. == mouse.id] <- (means[1]-means[5])
     return(gfl)
}

     
### Modify mouse dataframe

modify.mouse.dataframe <- function(mouse) {
  mouse$TotalTrial <- 1:nrow(mouse)
  mids <- tapply(mouse$Duration.in.nontarget.s, mouse$Day, median)
  for (i in 1:nrow(mouse)) {
    mouse$diff.from.median[i] <- 1 / sqrt((abs(mids[mouse$Day[i]] - mouse$Duration.in.nontarget.s[i])+0.01))
    mouse$dist.from.median[i] <- mids[mouse$Day[i]] - mouse$Duration.in.nontarget.s[i]
  }
  return(mouse)
}

### fit behaviour 

fit.behaviour <- function(mouse) {
  mouse <- modify.mouse.dataframe(mouse)
  nlfit <- nls(Duration.in.nontarget.s ~ K*(TotalTrial^log2(b)), start=list(K=70, b=1), data=mouse, weights=mouse$diff.from.median)
  return(nlfit)
}

### add behaviour to gfl

add.behaviour.to.gfl <- function(gfl, mouse, mouse.id) {
  mf <- fit.behaviour(mouse)
  gfl$K[gfl$Mouse.. == mouse.id] <- coefficients(mf)[1]
  gfl$beta[gfl$Mouse.. == mouse.id] <- coefficients(mf)[2]
  gfl$predicted.last.day[gfl$Mouse.. == mouse.id] <- predict(mf, newdata=data.frame(TotalTrial=30))
  return(gfl)
}



#######################
#######################
#######################

############ Sub Program: Compute brain volume change ############
### load.csv
### ants.vols
### minctracc.vols

# Function: normalized to day 0 image and brain volume

load.csv<-function(csv=csv){
     gfl<-read.csv(csv)
     gfl$bname <- sub('.mnc','', gfl$Image)
     return(gfl)
}
 gfl<-load.csv(csv)
ants.vols<-function(gfl=gfl,vols,atlas=atlas,antsdir="/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/",pipedate=pipedate){

     gfl$ANTSjacobians<-0
     if(missing(vols)){
          vols<-NULL
     }
     for (i in 1:nrow(gfl)){
          gfl$ANTSjacobians[i]<-system(paste("ls ",antsdir,"mincANTS-",pipedate,"_long/",gfl$bname[i],"_final_linear_mincANTS_inverse_grid_0-log-determinant-fwhm0.2.2.mnc",sep=""),intern=T)
     }
     vols$allvolsANTS<-anatGetAll(gfl$ANTSjacobians,atlas,defs="/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/taxibus-analysis/csv-files/c57_brain_atlas_labels_patrick.csv")
     vols$combinedvolsANTS <- anatCombineStructures(vols$allvolsANTS,defs="/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/taxibus-analysis/csv-files/c57_brain_atlas_labels_patrick.csv")
          vols$brainvolsANTS <- rowSums(vols$combinedvolsANTS)
          vols$NormVolumesANTS <- mat.or.vec(nrow(gfl),ncol(vols$combinedvolsANTS))
          for (w in 1:ncol(vols$combinedvolsANTS)){
                    for (i in 1:nrow(gfl)){
                    vols$NormVolumesANTS[i,w] <- vols$combinedvolsANTS[i,w] - vols$combinedvolsANTS[gfl$Mouse.. == gfl$Mouse..[i] & gfl$Day == 0, w]
                    }
          }
          colnames(vols$NormVolumesANTS) <- colnames(vols$combinedvolsANTS)
     return(vols)
}

add.minctracc.vols<-function(gfl=gfl,atlas=atlas,pipedir="/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/",pipedate=pipedate,volumes){
     gfl$jacobians <- 0 # jacobians with fwhn of 0.5 used for VOXEL analysis
     if(missing(volumes)){
          vols<-NULL
     }

     for (i in 1:nrow(gfl)){
          gfl$jacobians[i]<-system(paste("ls ",pipedir,"invivo-",pipedate,"_processed/",gfl$bname[i],"/stats-volumes/",gfl$bname[i],"-log-determinant-fwhm0.5.mnc",sep=""),intern=T)
          print(gfl$jacobians[i])
     }
     #creates jacobian variable for those with fwhm 0.1 - used for STRUCTURE analysis
     gfl$smalljacobians <- sub('log-determinant-fwhm0.5.mnc', 'log-determinant-scaled-fwhm0.1.mnc', gfl$jacobians)
     # Acquire volumes in cubed mm (structure separated by right and left)
     vols$allvols <- anatGetAll(gfl$smalljacobians, atlas,defs="/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/taxibus-analysis/csv-files/c57_brain_atlas_labels_patrick.csv")
	# combined volumes (not separated by right and left)
	vols$combinedvols <- anatCombineStructures(vols$allvols,defs="/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/taxibus-analysis/csv-files/c57_brain_atlas_labels_patrick.csv")
# 	# acquire whole brain volume for each image
	vols$brainVolume <- rowSums(vols$combinedvols)
# 
	vols$NormVolumes <- mat.or.vec(nrow(gfl),ncol(vols$combinedvols))
	for (w in 1:ncol(vols$combinedvols)){
		for (i in 1:nrow(gfl)){
			vols$NormVolumes[i,w] <- vols$combinedvols[i,w] - vols$combinedvols[gfl$Mouse.. == gfl$Mouse..[i] & gfl$Day == 0, w]
		}
	}
         colnames(vols$NormVolumes)<- colnames(vols$combinedvols)
      return(vols)
	
}