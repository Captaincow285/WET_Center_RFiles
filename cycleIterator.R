library(readr)
library(chron)
library(dplyr)
library(plyr)
library(stringr)

data.df <- read.csv("data_June9_June12.csv")
data.df <- data.df %>%
  filter(between(as.POSIXct(data.df$DateTime), as.POSIXct("2023-06-15"), as.POSIXct("2023-06-18")))

#Rewrite cycles
prevInfluent <- 0
addInfluent <- 0
for (i in 1:nrow(data.df)){
  if (data.df$SumInfluent[i] < prevInfluent){
    addInfluent <- addInfluent + prevInfluent
  }
  prevInfluent <- data.df$SumInfluent[i]
  data.df$SumInfluent[i] <- data.df$SumInfluent[i] + addInfluent
}

motorPowers <- c("StartTime", "EndTime", "Motor1", "Motor2", "Motor3", "Motor4",
                 "Motor5", "Motor6", "Motor7", "Motor8", "Motor9")
powerCycle <- FALSE
prevSpeed <- 0
initInfluent <- 0
cycleStart <- 0
motorPowerList <- list()
cycleData <- data.frame(matrix(ncol=length(motorPowers), nrow=0))
colnames(cycleData) <- motorPowers

for (rowNum in 2:nrow(data.df)){
  
  #Sum cycles
  if (powerCycle & (data.df$SumInfluent[rowNum] - initInfluent > 1)){
    powerCycle <- FALSE
    motorPowerList[2] <- data.df$DateTime[rowNum]
    for (i in 1:9){
      motorPowerList[i + 2] <- sum(data.df[cycleStart:rowNum, paste0("Motor", i, "Power")])
    }
    cycleData[nrow(cycleData) + 1,] <- motorPowerList
  }
  
  #Detect start of cycles (is under sumCycle for reason)
  if (data.df$Motor2Speed[rowNum] > 35.00 & !powerCycle & prevSpeed == 35.00){
    powerCycle = TRUE
    cycleStart <- rowNum
    initInfluent <- data.df$SumInfluent[rowNum]
    
    motorPowerList[1] <- data.df$DateTime[rowNum]
  }
  
  prevSpeed <- data.df$Motor2Speed[rowNum]
}

basin1basin2scale <- c()
basin1basin3scale <- c()
#for (x in 1:length(basin1power)){
#  basin1basin2scale <- append(basin1basin2scale, (basin1power[x] / basin2power[x]))
#  basin1basin3scale <- append(basin1basin3scale, (basin1power[x] / basin3power[x]))
#}