library(readr)
WWTP.df <- read_csv("HydroWASTE_v10.csv")

WWTP.df <- subset(WWTP.df, CNTRY_ISO == "USA")

baseURL <- "http://www.google.com/maps/place/"
listURLs <- c()
for (i in 1:nrow(WWTP.df)){
  listURLs <- append(listURLs, paste0(baseURL, WWTP.df$LAT_WWTP[i], ",", WWTP.df$LON_WWTP[i]))
}
WWTP.df <- cbind(WWTP.df, listURLs)

write.csv(WWTP.df, "USA_WWTP.csv")

x <- floor(runif(100, min=1, max=nrow(WWTP.df)))

sampleWWTP.df <- WWTP.df[x,]
write.csv(sampleWWTP.df, "sample_USA_WWTP.csv")