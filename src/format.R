# Description: format.R formats the test data from long format to 
# wide format based on the mac id's of the sensor with multiple records along
# a time series
# 
# Author: knavero
###############################################################################

quit = FALSE;
types = vector(mode = "character")
count = 1

print("Type description: ")
print("NULL type will remove a column from the data frame")
print("character type will represent a string")
print("numeric type will represent a number with double precision")

while(!quit) {
   value = readline(paste("Column", count, ".", "Enter a type name(NULL, character, numeric): "))  
   
   switch (value, 
      NULL = { 
         print(value)
         types = c(types, value)
      },
      
      character = {
         print(value)
         types = c(types, value)
      },
      
      numeric = {
         print(value)
         types = c(types, value)
      },
      
      quit = {
         quit = TRUE
      },
      
      {
         print('Invalid type. Try again')
         count = count - 1
      }
   )
   
   count = count + 1
}

print("The columns will be identifed as such: ")
print(types)

timeIndex = as.numeric(readline("Which column contains the timestamps (Do NOT count the NULL columns)?"))
splitColumn = as.numeric(readline("Which column is the column you would like to split into wide format 
Do NOT count the NULL columns)?"))     

setwd("~/Desktop/r_workspace/TestData/resources")
file = readline("Enter the name of the csv file you want to format (file must be in resources folder): ")
print("Processing...")

print("Reading csv...")
data = read.csv(file = file, header = TRUE, colClasses = types)
print("Finished reading csv!")

print("Initializing data frame...")
index = as.POSIXct(data[,timeIndex], origin = "1970-01-01", tz = "GMT")
data[,timeIndex] = index
print("Finished initializing data frame!")

print("Reshaping data frame to wide format...")
wdata = reshape(data, idvar = names(data[timeIndex]), timevar = names(data[splitColumn]), direction = "wide")
print("Finished reshaping data frame to wide format!")

print("Writing file to output folder...")
write.csv(wdata, "../output/out.csv", na = "")
print("File written to output folder!")
