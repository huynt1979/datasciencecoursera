library(plyr)
library(stringr)

# Question 1
dataDir <- '/home/hnguyen/projects/datasciencecoursera/GettingCleaningData/quiz4/'
ohio <- read.csv(paste(dataDir, sep ="/", 'Ohio_housing_survey.csv'))
ohioColNames <- names(ohio)
strsplit(ohioColNames[123], split = "wgtp")

# Question 2
gdp <- read.csv(paste(dataDir, sep = "/", 'GDP.csv'), skip = 4)
gdp <- gdp[1:190, c(1,2,4,5)]
names(gdp) <- c("CountryCode", "Rank", "CountryName", "GDP")
gdp$NumericGDP <- as.numeric(str_replace_all(as.character(gdp$GDP), "," , ""))
mean(gdp$NumericGDP)

# Question 3
length(grep('^United', gdp$CountryName))

# Question 4
edu <- read.csv(paste(dataDir, sep = "/", "Education.csv"))
mergedData <- join(gdp, edu, by= "CountryCode", type= "inner", match = "all")
length(grep('Fiscal year end: June', mergedData$Special.Notes, ignore.case = TRUE))

# Question 5
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn) 

sample2012 <- sampleTimes[grepl('2012-', sampleTimes)]
length(grep('2012-', sampleTimes))
length(grep('Monday', weekdays(sample2012, abbreviate = FALSE)))
