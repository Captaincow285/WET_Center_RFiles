library(readr)
library(chron)
library(dplyr)
library(plyr)
library(stringr)
library(lubridate)

#Variables to edit
PLC_FileName <- ""  # Enter the filename and/or path of the PLC data
SCADA_FileName <- "" # Enter the filename and/or path of the SCADA data
rawPLC = TRUE  # Should be True if the file was just downloaded from the Stridelinx portal


# Read, set up time, and clean PLC data
PLC.df <- read_csv(PLC_FileName)
PLC.df$time <- as.POSIXct(PLC.df$time, format = "%Y-%m-%d %H:%M:%S", tz="UTC")

# This statement reverses the PLC data, since it comes from the Stridelinx in reverse order
if (rawPLC){
  PLC.df <- rev(as.data.frame(t(PLC.df)))
  PLC.df <- as.data.frame(t(PLC.df))
}

#Read SCADA time and use it to clean up
SCADA.df <- read.csv(SCADA_FileName)
SCADA.df$Date <- as.POSIXct(SCADA.df$Date, format="%d/%m/%Y")
SCADA.df$DateTime <- as.POSIXct(paste(SCADA.df$Date, SCADA.df$Time), format = "%Y-%m-%d %H:%M:%S", tz="UTC")

PLC.df$time <- as.POSIXct(PLC.df$time, format="%Y-%m-%d %H:%M:%S", tz="UTC")
startDate <- round_date(PLC.df$time[1], unit="day")
endDate <- round_date(PLC.df$time[length(PLC.df$time)], unit="day")
timeList <- seq(as.POSIXct(startDate), as.POSIXct(endDate), by = "1 min")


#Clean the SCADA data and remove all unneeded variables
dropList <- c()
#Automatically extracts columns of motor speed and DO
for (i in 1:(length(colnames(SCADA.df))-1)){
  if (("X.PS1.AER" %in% str_extract(colnames(SCADA.df[i]), "X.PS1.AER") 
       & "SCALED_DO" %in% str_extract(colnames(SCADA.df[i]), "SCALED_DO"))
      | "COMAND_SPEED" %in% str_extract(colnames(SCADA.df[i]), "COMAND_SPEED")
      | "SCALED_ORP" %in% str_extract(colnames(SCADA.df[i]), "SCALED_ORP")){
    dropList <- append(dropList, i)
  }
}
dropList <- append(dropList, which(colnames(SCADA.df) == "X.PCC.PLANT_TOTAL_INF_FLOW_REALTIME"))
dropList <- append(dropList, which(colnames(SCADA.df) == "X.PCC.UMASS_INF_FLOW_SCALED"))
dropList <- append(dropList, which(colnames(SCADA.df) == "X.PCC.PLANT_TOTAL_INF_FLOW"))
SCADA.df <- SCADA.df[c(dropList, ncol(SCADA.df))]

#Generate dataframe to merge data into
columnNames <- c("DateTime", "Motor1Power", "Motor1Speed", "Motor1_DO", "Motor1_ORP", "Motor2Power", "Motor2Speed", "Motor2_DO", "Motor2_ORP", 
                 "Motor3Power", "Motor3Speed", "Motor3_DO", "Motor3_ORP", "Motor4Power", "Motor4Speed", "Motor4_DO", "Motor4_ORP",
                 "Motor5Power", "Motor5Speed", "Motor5_DO", "Motor5_ORP", "Motor6Power", "Motor6Speed", "Motor6_DO", "Motor6_ORP",
                 "Motor7Power", "Motor7Speed", "Motor7_DO", "Motor7_ORP", "Motor8Power", "Motor8Speed", "Motor8_DO", "Motor8_ORP",
                 "Motor9Power", "Motor9Speed", "Motor9_DO", "Motor9_ORP", "TotalInfluent", "UMassInfluent", "SumInfluent")
lengthSCADA <- length(columnNames)
DATA.df <- data.frame(matrix(ncol = lengthSCADA, nrow = 0)) #length(time)
colnames(DATA.df) <- columnNames

# Loop through the Time vector and generate data for it
for (i in 2:length(timeList)){
  # Setting up variables for list
  row = list()
  for (k in 1:lengthSCADA){
    row[k] <- 1
  }
  row[1] <- toString(as.POSIXct(timeList[i]), format = "%m/%d/%Y %H:%M:%S", tz="UTC")
  
  #Subsetting the data based on time intervals
  plcMinute.df <- PLC.df %>%
    filter(between(PLC.df$time, timeList[i-1], timeList[i]))
  #PLC.df$time < as.POSIXct(time[i]) & PLC.df$time > as.POSIXct(time[i - 2])
  scadaMinute.df <- SCADA.df %>%
    filter(SCADA.df$DateTime < as.POSIXct(timeList[i]) & SCADA.df$DateTime > as.POSIXct(timeList[i - 1]))
  
  print(timeList[i])
  
  #Generating the averages of the time interval
  for (k in 1:9){
    #Avgs and inserts True Power (PLC data)
    avg <- mean(plcMinute.df[[k+1]])
    # print(avg)
    row[(k*4)-2] <- avg
    
    #Avgs and inserts Dissolved Oxygen (SCADA data)
    doName <- paste("X.PS1.AER_", toString(k), "_SCALED_DO", sep="")
    avg <- mean(scadaMinute.df[,doName])
    row[(k*4)] <- avg 
    
    #Avgs and inserts Motor Speed (SCADA Data)
    csName <- paste("X.PS1.AR_", toString(k), "_COMAND_SPEED", sep="")
    avg <- mean(scadaMinute.df[,csName])
    # print(avg)
    row[(k*4)-1] <- avg
    
    orpName <- paste(paste("X.PS1.AR_", toString(k), "_SCALED_ORP", sep=""))
    avg <- mean(scadaMinute.df[,orpName])
    row[(k*4)+1] <- avg
  }
  
  row[38] <- mean(scadaMinute.df$X.PCC.PLANT_TOTAL_INF_FLOW_REALTIME)
  row[39] <- mean(scadaMinute.df$X.PCC.UMASS_INF_FLOW_SCALED)
  row[40] <- mean(scadaMinute.df$X.PCC.PLANT_TOTAL_INF_FLOW)
  
  DATA.df[(nrow(DATA.df) + 1),] <- row
}

# DATA.df <- na.omit(DATA.df)
write.csv(DATA.df, "data.csv", row.names=FALSE)
