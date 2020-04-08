### Calculate right side p values for each measure ~ each structure

for (i in 1:12){ #for each measure of interest, in columns 1:12

     for (j in 1:11){ # for each structure of interest
          for (k in 1:3){ # for each group
          VAR<-thyroid2.copy[,i]
          STRUC<-thyroid2.copy[,j+14]
          th.lm<-summary(lm(VAR~STRUC*Group+Age+Gender+rThickMean,thyroid2))

          DF[i,j,k]<-coef(th.lm)[k+8,4]

          }
     }
     rownames(DF)<-names(thyroid2.copy[1:12])
     colnames(DF)<-names(thyroid2.copy[15:36])
}


### Left Side:
for (i in 1:12){ #for each measure of interest, in columns 1:12

     for (j in 12:22){ # for each left structure of interest
          for (k in 1:3){ # for each group
          VAR<-thyroid2.copy[,i]
          STRUC<-thyroid2.copy[,j+14]
          th.lm<-summary(lm(VAR~STRUC*Group+Age+Gender+lThickMean,thyroid2))

          DF[i,j,k]<-coef(th.lm)[k+8,4]

          }
     }
     rownames(DF)<-names(thyroid2.copy[1:12])
     colnames(DF)<-names(thyroid2.copy[15:36])
}