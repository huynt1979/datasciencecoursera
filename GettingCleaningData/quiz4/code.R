# Question 1
dataDir <- '/home/hnguyen/projects/datasciencecoursera/GettingCleaningData/quiz4/'
ohio <- read.csv(paste(dataDir, sep ="/", 'Ohio_housing_survey.csv'))
ohioColNames <- names(ohio)
strsplit(ohioColNames[123], split = "wgtp")

# Question 2
library(plyr)
library(stringr)
gdp <- read.csv(paste(dataDir, sep = "/", 'GDP.csv'), skip = 4)
gdp <- gdp[1:190, c(1,2,4,5)]
names(gdp) <- c("CountryCode", "Rank", "CountryName", "GDP")
gdp$NumericGDP <- as.numeric(str_replace_all(as.character(gdp$GDP), "," , ""))
mean(gdp$NumericGDP)