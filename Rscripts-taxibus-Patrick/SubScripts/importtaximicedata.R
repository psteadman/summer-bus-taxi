initial.wd2=getwd()
setwd("/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/taxibus-analysis/behavioural-data/taximice")
taximicefiles<-list.files(pattern= "^[mouse]" )
header.names<-c("ignore","Mouse","Day","Trial","Distance.moved.cm.total","Distance.to.target.cm.mean","Distance.to.target.cm.total","Heading.mean.centre.pt","Velocity.cm.s.mean","Duration.in.any.nontarget.s","Freq.in.any.nontarget","Latency.head.directed.to.target.s","Latency.to.target.s")
for (folder in taximicefiles){
mouse.nam<-folder
mouse.nam<-sub('.csv','',mouse.nam)
DF<-NULL
DF<-read.table(folder, skip=4,sep=",",header=F)
DF[,13]<-as.numeric(as.character(DF[,13]))
colnames(DF)<-header.names
assign(mouse.nam,DF,envir=.GlobalEnv)}


