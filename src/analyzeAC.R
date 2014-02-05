# TODO: Add comment
# 
# Author: knavero
###############################################################################

FMT = "%Y-%m-%d %H:%M:%S"

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

# Capture the data you want to work with i.e. the mac_id with the smallest average
data = subset(wdata, !is.na(wdata[min$id]))
data = data.frame(data[,1], data[min$id])

xlt = strptime(data[,1], format = FMT)
data = data.frame(data, xlt) #tag on POSIXlt objects
data$xlt = strptime(data$xlt, format = FMT) #convert to POSIXlt

data = data.frame(data, data[,3]$wday) #tag on isWeekday variable
names(data) = c("ts", "data", "xlt", "iswd")

# Analyze the weekdays
data = subset(data, iswd != 0 & iswd != 6)

# If data is greater than 0.5 then subtract 0.5 from it
delta = ifelse(data$data > 0.5, data$data - 0.5, 0)
reduced = data$data - delta
data = data.frame(data, delta, reduced)


