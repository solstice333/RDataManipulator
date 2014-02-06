# TODO: Add comment
# 
# Author: knavero
###############################################################################
library(zoo)
library(chron)

FMT = "%Y-%m-%d %H:%M:%S"

cat("Finding minimum...\n")
# Create a name lookup table for the mac_id associating to its average for values greater
# than 0.7
average = vector(mode = "numeric")
id = vector(mode = "numeric")

for (i in 2:length(wdata)) {
   v = na.omit(wdata[,i])
   v = v[v > 0.5]
   average = c(average, mean(v))
   
   id = c(id, i)
}

map = data.frame(id, names(wdata[2:length(wdata)]), average)
names(map) = c("id", "mac_id", "average")

# Find the mac_id with the smallest average
min = subset(map, is.finite(map$average))
min = subset(min, min$average == min(min$average))

cat("Linear interpolating values for empty bins...\n")
# linear interpolate NA's within data frame
data = wdata[2:length(wdata)]
data = zoo(data, order.by = wdata[,1])
ts = seq(from = start(data), to = end(data), by = 30 * 60)
data = na.approx(object = data, xout = ts)
data = data.frame(ts, data)

cat("Adding POSIXlt and weekday columns...\n")
# Add POSIXlt and weekday column
xlt = strptime(data[,1], format = FMT)
data = data.frame(data, xlt) #tag on POSIXlt objects (which changes it back to ct)
data$xlt = strptime(data$xlt, format = FMT) #convert to POSIXlt

data = data.frame(data, data$xlt$wday) #tag on day variable
names(data)[length(data)] = "wd"

cat("Removing weekends...\n")
# parse the days and remove weekends
data = subset(data, wd != 0 & wd != 6) 

cat("Calcuating the reduction...\n")
# If data is greater than 0.5 then subtract 0.5 from it
delta = ifelse(data[,min$id] > 0.5, data[,min$id] - 0.5, 0)
data = data.frame(data, delta)
orig = data

cat("Creating reduced values...\n")
# Obtain the reduced values. Don't forget to na.omit when jittering
for (i in 2:(length(data) - 3)) {
   data[,i] = ifelse(data[,i] - delta < 0, 0, data[,i] - delta)
}
