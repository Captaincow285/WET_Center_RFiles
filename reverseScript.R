library(readr)

fileName <- "PLC_Aug17.csv"

reversed.df <- read.csv(paste0("C:/Users/Capta/Desktop/WET Center Data/RProject/", fileName))

reversed.df$Motor.10 <- NULL
reversed.df$Motor.11 <- NULL

transposed.df <- rev(as.data.frame(t(reversed.df)))
output.df <- as.data.frame(t(transposed.df))
write.csv(output.df, fileName, row.names = FALSE)

