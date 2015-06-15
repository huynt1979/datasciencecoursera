complete <- function(directory, id = 1:332) {
  result <- data.frame()
  for (i in id) {
    d <- read.csv(paste(directory, sprintf("%03d.csv", i), sep="/"))
    fdata <- data.frame("id" = i, "nobs" = nrow(d[complete.cases(d), ]))
    result <- rbind(result, fdata)
  }
  
  result
}