rankall <- function(outcome, num = "best") {
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
  
  
  result <- data.frame()
  # For each state, find the hospital of the given rank
  for (st in levels(allStateData$State)) {
    stateData <- allStateData[allStateData$State == st, ]  
    orderData <- as.character(stateData[order(stateData[[outcome]], stateData$Hospital), "Hospital"])
    
    if (num == "best") {
      hospitalName <- orderData[1]
    } else if (num == "worst") {
      hospitalName <- orderData[length(orderData)]
    } else if (is.numeric(num) && num <= length(orderData)){
      hospitalName <- orderData[num]
    } else {
      hospitalName <- NA
    }
    
    rowResult <- data.frame("hospital" = hospitalName, "state" = st, row.names = st)
    result <- rbind(result, rowResult)
  }
  
  result
}
