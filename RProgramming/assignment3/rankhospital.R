rankhospital <- function(state, outcome, num = "best") {
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
  
  orderData <- as.character(stateData[order(stateData[[outcome]], stateData$Hospital), "Hospital"])
  if (num == "best") {
    orderData[1]
  } else if (num == "worst") {
    orderData[length(orderData)]
  } else if (is.numeric(num) && num <= length(orderData)){
    orderData[num]
  } else {
    NA
  }
  
#   if (num == "best") {
#     rankValue <- min(stateData[[outcome]])
#   } else if (num == "worst") {
#     rankValue <- max(stateData[[outcome]])
#   } else {
#     rankValue <- stateData[ rank(stateData[[outcome]], ties.method = "first") == num, c(outcome)]
#   }
#   
#   sort(as.character(stateData[stateData[[outcome]] == rankValue, "Hospital"]))
}