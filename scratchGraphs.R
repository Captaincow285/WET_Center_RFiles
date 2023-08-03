plotData.df <- data.df %>%
  filter(between(as.POSIXct(data.df$DateTime), as.POSIXct("2023-06-15"), as.POSIXct("2023-06-18")))

motorData.df <- plotData.df[1:500,c(6,10,18,22,30,34)]

labels <- c("Motor 2", "Motor 3", "Motor 5", "Motor 6", "Motor 8", "Motor 9")
matplot(motorData.df, type="l", col=1:6, pch=1)
legend("topright", legend=labels, col=1:6, pch=1)

matplot(motorData.df[1:250,1:2], type="l", col=1:2, pch=1)
legend("topright", legend=labels[1:2], col=1:2, pch=1)

matplot(motorData.df[1:250,3:4], type="l", col=1:2, pch=1)
legend("topright", legend=labels[3:4], col=1:2, pch=1)

matplot(motorData.df[125:375,5:6], type="l", col=1:2, pch=1)
legend("topright", legend=labels[5:6], col=1:2, pch=1)