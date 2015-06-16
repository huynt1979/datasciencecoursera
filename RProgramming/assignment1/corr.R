corr <- function(directory, threshold = 0) {
  cc <- complete(directory)
  ct <- cc[cc$nobs > threshold, ]
  
  if (length(ct) == 0) {
    0
  } else {
  
    result <- NULL
    for (i in ct$id) {
      di <- read.csv(paste(directory, sprintf("%03d.csv", i), sep="/"))
      cdi <- di[complete.cases(di), ]
      result <- c(result, round(cor(cdi[, c("sulfate")], cdi[, c("nitrate")]), digits = 5))
    }

    result
  }
}