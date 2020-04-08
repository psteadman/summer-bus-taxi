modify.mouse.dataframe <- function(mouse) {
  mouse$TotalTrial <- 1:nrow(mouse)
  mids <- tapply(mouse$Latency.to.target.s, mouse$Day, median)
  for (i in 1:nrow(mouse)) {
    mouse$diff.from.median[i] <- 1 / sqrt((abs(mids[mouse$Day[i]] - mouse$Latency.to.target.s[i])+0.01))
    mouse$dist.from.median[i] <- mids[mouse$Day[i]] - mouse$Latency.to.target.s[i]
  }
  return(mouse)
}

fit.behaviour <- function(mouse) {
  mouse <- modify.mouse.dataframe(mouse)
  nlfit <- nls(Latency.to.target.s ~ K*(TotalTrial^log2(b)), start=list(K=70, b=1), data=mouse, weights=mouse$diff.from.median)
  return(nlfit)
}


add.behaviour.to.gfl <- function(gfl, mouse, mouse.id) {
  mf <- fit.behaviour(mouse)
  gfl$K[gfl$Mouse.. == mouse.id] <- coefficients(mf)[1]
  gfl$b[gfl$Mouse.. == mouse.id] <- coefficients(mf)[2]
  gfl$predicted.last.day[gfl$Mouse.. == mouse.id] <- predict(mf, newdata=data.frame(TotalTrial=30))
  return(gfl)
}
                          
                          
