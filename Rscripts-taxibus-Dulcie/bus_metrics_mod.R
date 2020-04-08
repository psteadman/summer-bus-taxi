# bus_metrics.R
# June 15 2010
#
# This script does the following:
# Given a list of csv files and a list of mouse numbers, mouse_metrics.R creates an R object 
# for each mouse number. The mouse object contains the data from the csv file. 
# It then extracts metrics of interest (currently time in non-target holes and velocity, 
# but can be expanded to extract any metric). Organizes metrics into a table in which each row
# corresponds to one mouse and each column corresponds to one metric of one trial of one day.
#
# Before running this script, the following variables must be defined within the R workspace: 
#
#    mouse.files - a list of paths to csv files
#    mouse.sep - the delimiter used in the csv file, [default: ","]
#    mouse.numbers - a list of the mouse numbers (in the same order as the list of files)
#    first - day # corresponding to first day of training [default: 1]
#    last - day # corresponding to last day of training [default: 5]
#    trials - number of trials [default: 6]
#    lat.col - column number of csv file corresponding to time in non-target holes 
#    v.col - column number of csv file corresponding to velocity
#
# Individual mouse objects can be accessed by:
#    buslist$mousei (where i = mouse number)
#    mouse.i
# The table of mouse metrics can be accessed by busmice.metrics

# Function: mouse.import
# Import data from mouse .csv file
# Create mouse object for each file
# User should specify the following:
#    mouse.files - a list of paths to csv files, eg mouse.files=c("/dir/mouse1.csv","/dir/mouse2.csv")
#    mouse.numbers - a list of mouse numbers (in same order as list of files) eg mouse.numbers=c(41,30,10)
#    mouse.sep - the delimiter used in the csv file eg. ","


mouse.import<-function(mouse.file,mouse.number,mouse.sep=","){
mouse.nam<-paste("mouse",mouse.number,sep=".")
mouse.temp<-read.table(mouse.file,sep=mouse.sep)
mouse.data<-mouse.temp[-c(1:4),]
colnames(mouse.data)<-apply(mouse.temp[1:4,],2,paste,collapse="::")
assign(mouse.nam,mouse.data,envir=.GlobalEnv)
return(mouse.data)
}

# Function: getmetric
# Rearrange data from mouse .csv file into a table such that each row corresponds to a mouse
# User should specify the following:
#    first = first day
#    last = last day
#    trials = number of trials
#    mousemetric = name of metric of interest
#    busmice.list = list of mice
#    metric.col = index of column of metric of interest 

getmetric<- function(mousemetric,first=1,last=5,trials=6,busmice.list,metric.col){
     column.names<-c()
     busmice.table<-c()
     days<<-(last-first+1)
     k = days*trials
     trial.num <- 1;
     day.num<-first;
     for (i in 1:k){
          column.names[i]<- paste(day.num,trial.num,mousemetric,sep="_")
          trial.num<-trial.num+1
          if (trial.num > trials){
               trial.num <-1
               day.num <- day.num+1
          }
     }
     

     for (i in 1:length(busmice.list)){
     busmice.list[[i]][,metric.col]<-as.numeric(as.character(busmice.list[[i]][,metric.col]))
     busmice.table <- rbind(busmice.table,busmice.list[[i]][,metric.col])

     }
     colnames(busmice.table)<-column.names
     busmice.metrics<<-cbind(busmice.metrics,busmice.table)
#      busmice.metrics
}

# User specified arguments:
# mouse.sep=","
# mouse.numbers=c(6,7,11,12,13)
# mouse.files=c("Bus_retrack/Mouse_6_bus_retrack_051810analysis.csv","Bus_retrack/Mouse_7_bus_retrack_051810analysis.csv","Bus_retrack/Mouse_11_bus_retrack_051810analysis.csv","Bus_retrack/Mouse_12_bus_retrack_051810analysis.csv","Bus_retrack/Mouse_13_bus_retrack_051810analysis.csv")
# 
# first <- 3
# last<-5
# trials <-4
# #busmice.list<-list(mouse6=mouse6,mouse7=mouse7,mouse11=mouse11,mouse12=mouse12,mouse13=mouse13)
# lat.col <- 6
# v.col<-211

#######################################
#### Program starts here:
#######################################
velocity <- "velocity (cm/s)"
# latency <- "latency_to_target"
latency <- "time_in_non-target"
buslist<-list()
for (i in 1:length(mouse.files)){
     mouse.file<-mouse.files[i]
     mouse.number<-mouse.numbers[i]
     buslist[[paste("mouse",mouse.number,sep="")]]<-mouse.import(mouse.file,mouse.number,mouse.sep)
}
busmice.metrics<-matrix(nrow=length(buslist),ncol=0)
rownames(busmice.metrics)<-names(buslist)
getmetric(latency,first,last,trials,buslist,lat.col)
getmetric(velocity,first,last,trials,buslist,v.col)
tottrials<-days*trials

busmice.metrics<<-replace(busmice.metrics[,1:tottrials],is.na(busmice.metrics[,1:tottrials]),180) # replaces all the NA values for latency to target with 180. This is obviously not a nice way to do this since it assumes latency is first


# make and save latency to target plots

par(ask=TRUE)
for (i in 1:nrow(busmice.metrics)){
     plotname<-paste("mouse",mouse.numbers[i],"time_in_non-target.pdf",sep="_")
     print(qplot(1:tottrials,busmice.metrics[i,1:tottrials],geom=c("point","smooth"),xlab="Trial",ylab="Time in Non-Target Holes (sec)",main=paste("Mouse:",mouse.numbers[i],"Time in Non-Target Holes vs. Trial",sep=" ")))
     qplot(1:tottrials,busmice.metrics[i,1:tottrials],geom=c("point","smooth"),xlab="Trial",ylab="Time in Non-Target Holes (sec)",main=paste("Mouse:",mouse.numbers[i],"Time in Non-Target Holes vs. Trial",sep=" "))
     dev.copy(device=pdf,plotname)
     dev.off()
}
par(ask=FALSE)
# code works up to this point. 
# repeat for each metric.
