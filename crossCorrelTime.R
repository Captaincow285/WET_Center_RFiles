library(readr)
library(chron)
library(dplyr)
library(plyr)
library(stringr)
library(lubridate)

SCADA2.df <- read.csv("SCADA_March13_June20.csv")
SCADA2.df$Date <- as.POSIXct(SCADA2.df$Date, format="%d/%m/%Y")
SCADA2.df$DateTime <- as.POSIXct(paste(SCADA2.df$Date, SCADA2.df$Time), format = "%Y-%m-%d %H:%M:%S", tz="UTC")

DO <- SCADA2.df$X.PS1.AER_2_SCALED_DO[SCADA2.df$Date == "2023-05-19"]
ORP <- SCADA2.df$X.PS1.AR_2_SCALED_ORP[SCADA2.df$Date == "2023-05-19"]
POWER <- SCADA2.df$X.PS1.AR_2_COMAND_SPEED[SCADA2.df$Date == "2023-05-19"]
TIME <- SCADA2.df$DateTime[SCADA2.df$Date == "2023-05-19"]

x <- ccf(POWER, DO, plot=TRUE)
y <- ccf(ORP, DO, 100, plot=TRUE)

dataset.df <- data.frame(log(POWER), log(lag(DO, n=20)), log(lag(ORP, n=60)))
dataset.df <- na.omit(dataset.df)
# dataset.df <- dataset.df[dataset.df$lagPower > 40]
colnames(dataset.df) <- c("lagPower", "lagDisOxy", "lagORP")

z <- lm(lagDisOxy ~ lagPower, dataset.df)

plot(dataset.df$lagDisOxy, type="l")
plot(dataset.df$lagPower, type="l")

mean(z$residuals)
plot(z$residuals[1:2000], type="l")