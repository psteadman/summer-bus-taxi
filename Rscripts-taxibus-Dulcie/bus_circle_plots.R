#arguments:
#    trials
#
# right now is within 2 holes, tricky to make error value variable

circleplot<-function(mouse,mouse.num,mytrials,lat_hole1,col_int){
     trial.names<-c()
     hole.names<-c()

     nam<-paste("mouse",mouse.num,"latencytoholes",sep=".")
     nam2<-paste("mouse",mouse.num,"latencywithinerror",sep=".")
     nam3<-paste("mouse",mouse.num,"latencycounts",sep=".")
     lat_holes<-matrix(nrow=mytrials,ncol=40)
     lat_counts<-matrix(rep(0,(mytrials+1)*40),nrow=mytrials+1,ncol=40)

     for (i in 1:mytrials){
          trial.names[i]<- paste("trial",i,sep="_")
     }

     for (i in 1:40){
          hole.names[i]<- paste("hole",i,sep="_")
     }
     
     rownames(lat_holes)<-trial.names
     colnames(lat_holes)<-hole.names
     rownames(lat_counts)<-c(trial.names,"total")
     colnames(lat_counts)<-hole.names
     lat_within_error<-lat_holes

     x <- lat_hole1
     k <-col_int
     
     for (i in 0:39){
          lat_holes[,i+1]<-as.numeric(as.character(mouse[,x+k*i]))
     }
     for (i in 1:mytrials){
          for (j in 3:38){
               lat_within_error[i,j]<-min(lat_holes[i,j-2],lat_holes[i,j-1],lat_holes[i,j],lat_holes[i,j+1],lat_holes[i,j+2],na.rm=TRUE)
          }
          lat_within_error[i,1] <- min(lat_holes[i,40], lat_holes[i,39], lat_holes[i,1], lat_holes[i,2], lat_holes[i,3], na.rm=TRUE)
     
          lat_within_error[i,2] <- min(lat_holes[i,40], lat_holes[i,4], lat_holes[i,1], lat_holes[i,2], lat_holes[i,3], na.rm=TRUE)
          
          lat_within_error[i,39] <- min(lat_holes[i,38], lat_holes[i,39], lat_holes[i,37], lat_holes[i,2], lat_holes[i,1], na.rm=TRUE)
          
          lat_within_error[i,40] <- min(lat_holes[i,38], lat_holes[i,39], lat_holes[i,1], lat_holes[i,2], lat_holes[i,40], na.rm=TRUE)
     }
     for (i in 1:mytrials){
          for (j in 1:40){
               if (lat_within_error[i,j]==min(lat_within_error[i,], na.rm=TRUE)){
                    lat_counts[i,j]<-lat_counts[i,j]+1
               }
          }
     }
     for (i in 1:40){
          lat_counts[mytrials+1,i]<-sum(lat_counts[,i],na.rm=TRUE)
     }
     
     
          
     
     assign(nam,lat_holes,envir=.GlobalEnv)
     assign(nam2,lat_within_error,envir=.GlobalEnv)
     assign(nam3,lat_counts,envir=.GlobalEnv)
     cplot <- qplot(1:40,lat_counts[nrow(lat_counts),],geom=c("line","point"),main=paste("Mouse",mouse.num,": Number of Times Each Hole (+/- 2 Holes) Visited First")) + coord_polar()
     plotname<-paste("mouse",mouse.num,"latencywithinerror",sep="")
     plotname<-paste(plotname,"ps",sep=".")
     dev.copy(postscript,plotname)
     dev.off()
}


