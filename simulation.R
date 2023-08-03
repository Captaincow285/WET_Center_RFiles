simulation.df <- data.frame()
colnames(simulation.df) <- c("Time", "")

cycle <- 240
timeList <- seq(as.POSIXct("2023-01-01"), as.POSIXct("2023-01-02"), by = "15 sec")

# DO target is 1.6; DO falloff is 0.97 per 15-sec interval @ 35% power
# for chosen low flow date June 15, 56% avg stable max injects 60L of O^2 per 15 sec
# Aerator is rated for 220L O^2/15 sec
# Flow is 2050L/15 sec


minute.list <- list()
for (min in 1:length(timeList)){
  list[1] <- i
  if (i % 240 < 180){
    
  }
}

#Need: ORP --> DO
# Factors: Total volume of water in basin, DO setpoint, O2 volume in water, motor power,
# Functions: Motor power --> DO; DO volume falloff