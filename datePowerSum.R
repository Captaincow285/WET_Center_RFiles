library(dplyr)

data_Aug10$DateTime <- as.POSIXct(data_Aug10$DateTime, format = "%m/%d/%Y %H:%M", tz='UTC')
dayAug <- data_Aug10 %>% 
  filter(between(data_Aug10$DateTime, 
                 as.POSIXct("2023-08-03", tz='UTC'), as.POSIXct("2023-08-04", tz='UTC')))

powerAug <- sum(dayAug$Motor4Power) + sum(dayAug$Motor5Power) + sum(dayAug$Motor6Power)
#  + sum(dayAug$Motor7Power) + sum(dayAug$Motor8Power) + sum(dayAug$Motor9Power)

data_07_18$DateTime <- as.POSIXct(data_07_18$DateTime, format = "%m/%d/%Y %H:%M", tz='UTC')
dayJuly <- data_07_18 %>% 
  filter(between(data_07_18$DateTime, 
                 as.POSIXct("2023-07-17", tz='UTC'), as.POSIXct("2023-07-18", tz='UTC')))

powerJuly <- sum(dayJuly$Motor4Power) + sum(dayJuly$Motor5Power) + sum(dayJuly$Motor6Power)

#  + sum(dayJuly$Motor7Power) + sum(dayJuly$Motor8Power) + sum(dayJuly$Motor9Power)
#  + sum(dayJuly$Motor1Power) + sum(dayJuly$Motor2Power) + sum(dayJuly$Motor3Power)

dayJuly <- data_06_27 %>% 
  filter(between(data_06_27$DateTime, 
                 as.POSIXct("2023-07-9", tz='UTC'), as.POSIXct("2023-07-10", tz='UTC')))