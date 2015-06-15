pollutantmean <- function(directory, pollutant = 'sulfate', id = 1:332) {
  colnames <- c('sulfate', 'nitrate')
  
  if (!pollutant %in% colnames) {
    stop("pollutant must be one of the following values: ['sulfate', 'nitrate']")
  }
  
  if (is.null(id) | length(id) == 0) {
    stop("id must be a vector")
  }
  
  data <- data.frame()
  
  for (i in id) {
    fname <- paste(d, sprintf("%03d.csv", i), sep="/")
    data <- rbind(data, read.csv(fname, header = TRUE))
  }
   
  data <- data[!is.na(data[c(pollutant)]), ]
  
  format(mean(data[, c(pollutant)]), digits = 4)
}