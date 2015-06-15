corr <- function(directory, threshold = 0) {
  cc <- complete(directory)
  ct <- cc[cc$nobs > threshold, ]
  
  if (length(ct) == 0) {
    0
  } else {
  
    data <- data.frame()
    for (i in ct$id) {
      di <- read.csv(paste(directory, sprintf("%03d.csv", i), sep="/"))
      cdi <- di[complete.cases(di), ]
      data <- rbind(data, cdi)
    }
    
    #data[, c("sulfate", "nitrate")]
    cor(data[, c("nitrate")], data[, c("sulfate")])
  }
}