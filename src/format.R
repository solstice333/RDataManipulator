# Description: format.R formats the test data from long format to 
# wide format based on the mac id's of the sensor with multiple records along
# a time series
# 
# TODO add in possibility of having the user input how many columns exist and
# selecting what class type belongs in which. Use readline, as.numeric, and
# a bunch of if statements for parsing the class type maybe?
#
# Author: knavero
###############################################################################

print("Column format must be as follows: string, string, timestamp, sensorValue, sensorValue")

setwd("~/Desktop/r_workspace/TestData/resources")
file = readline("Enter the name of the csv file you want to format (file must be in resources folder): ")
print("Processing...")

data = read.csv(file = file, header = TRUE, colClasses = rep(c("NULL", "character", "numeric"), c(1, 1, 3)))
index = as.POSIXct(data[,2], origin = "1970-01-01", tz = "GMT")
data = data.frame(index, data[1], data[3], data[4])
wdata = reshape(data, idvar = names(data[1]), timevar = names(data[2]), direction = "wide")

write.csv(wdata, "../output/out.csv", na = "")
print(c("File written to output folder"))
