### Calculate right side p values for each measure ~ each structure

for (i in 1:16){ #for each measure of interest, in columns 1:12

     for (j in 1:11){ # for each structure of interest
          VAR<-thyroid2.subset[thyroid2.subset$Group=="0",i]
          STRUC<-thyroid2.subset[thyroid2.subset$Group=="0",j+18]
          th.lm<-summary(lm(VAR~STRUC+rThickMean[thyroid2.subset$Group=="0"],thyroid2))
          DF.group0[i,j]<-coef(th.lm)[2,4]
          }
      rownames(DF.group0)<-names(thyroid2.subset[1:16])
      colnames(DF.group0)<-names(thyroid2.subset[19:40])
}

for (i in 1:16){ #for each measure of interest, in columns 1:12

     for (j in 12:22){ # for each structure of interest
          VAR<-thyroid2.subset[thyroid2.subset$Group=="0",i]
          STRUC<-thyroid2.subset[thyroid2.subset$Group=="0",j+18]
          th.lm<-summary(lm(VAR~STRUC+lThickMean[thyroid2.subset$Group=="0"],thyroid2))
          DF.group0[i,j]<-coef(th.lm)[2,4]
          }
      rownames(DF.group0)<-names(thyroid2.subset[1:16])
      colnames(DF.group0)<-names(thyroid2.subset[19:40])
}



### Left Side:
for (i in 1:12){ #for each measure of interest, in columns 1:12

     for (j in 12:22){ # for each left structure of interest
          for (k in 1:3){ # for each group
          VAR<-thyroid2.copy[,i]
          STRUC<-thyroid2.copy[,j+14]
          th.lm<-summary(lm(VAR~STRUC+Age+Gender+lThickMean,thyroid2))

          DF[i,j,k]<-coef(th.lm)[k+8,4]

          }
     }
     rownames(DF)<-names(thyroid2.copy[1:12])
     colnames(DF)<-names(thyroid2.copy[15:36])
}