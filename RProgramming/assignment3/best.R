best <- function(state, outcome) {
  outcomes <- c("heart attack", "heart failure", "pneumonia")
  ## Check state and outcome are valid
  if (!outcome %in% outcomes) {
    stop("invalid outcome")
  }
  
  ## 30-day mortality rate columns for the above outcome
  mortalityCols <- c(11, 17, 23)
  names(mortalityCols) <- outcomes
  columnNumber <- mortalityCols[outcome]
  
  ## Read outcome data
  data <- read.csv("outcome-of-care-measures.csv")
  
  # Read only the needed column
  allStateData <- data[, c(2, 7, columnNumber)]
  
  # Assign better column name
  colnames(allStateData) <- c("Hospital", "State", outcome)
  
  # Convert mortality rate column to numeric
  allStateData[, outcome] <- as.numeric(allStateData[, outcome])
  
  if (!state %in% levels(allStateData$State)) {
    stop("invalid state")
  }
  

  # Get specific state data
  stateData <- allStateData[allStateData$State == state, ]
  
  minValue <- min(stateData[[outcome]])
  
  minHospitals <- sort(as.character(stateData[stateData[[outcome]] == minValue, "Hospital"]))
  
  minHospitals[1]
}