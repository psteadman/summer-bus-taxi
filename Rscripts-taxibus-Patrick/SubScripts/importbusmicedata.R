initial.wd1=getwd()
setwd("/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/taxibus-analysis/behavioural-data/busmice")
busmicefiles<-list.files(pattern="^[mouse]")
header.names<-c("ignore","Mouse","Day","Trial","Distance.moved.cm.total","Distance.to.target.cm.mean","Distance.to.target.cm.total","Heading.mean.centre.pt","Velocity.cm.s.mean","Duration.in.any.nontarget.s","Freq.in.any.nontarget","Latency.head.directed.to.target.s","Latency.to.target.s","")
for (folder in busmicefiles){
mouse.nam<-folder
tempfiles<-list.files(folder)
DF<-NULL
for (f in tempfiles){
dat<-read.table(paste(folder,f,sep="/"), skip=4,sep=",",header=F)
dat[,13]<-as.numeric(as.character(dat[,13]))
DF<-rbind(DF,dat)}
#DF[,13]<-is.numeric(DF[,13])
colnames(DF)<-header.names
assign(mouse.nam,DF,envir=.GlobalEnv)}
