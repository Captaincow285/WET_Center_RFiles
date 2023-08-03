library(readr)

reversed.df <- read.csv("C:/Users/Capta/Desktop/WET Center Data/RProject/pinned5.csv")

reversed.df$Motor.10 <- NULL
reversed.df$Motor.11 <- NULL

transposed.df <- rev(as.data.frame(t(reversed.df)))
output.df <- as.data.frame(t(transposed.df))
write.csv(output.df, "pinned5.csv", row.names = FALSE)
