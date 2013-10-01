# Description: format.R formats the test data from long format to 
# wide format based on the mac id's of the sensor with multiple records along
# a time series
# 
# Author: knavero
###############################################################################

done = FALSE;
types = vector(mode = "character")
count = 1

cat("Type description: \n")
cat("NULL type will remove a column from the data frame\n")
cat("character type will represent a string\n")
cat("numeric type will represent a number with double precision\n")

while(!done) {
   value = readline(paste("Column", count, ".", "Enter a type name(NULL, character, numeric). Type 'done' when finished: "))  
   
   switch (value, 
      NULL = { 
         cat(paste(value, '\n'))
         types = c(types, value)
      },
      
      character = {
         cat(paste(value, '\n'))
         types = c(types, value)
      },
      
      numeric = {
         cat(paste(value, '\n'))
         types = c(types, value)
      },
      
      done = {
         done = TRUE
      },
      
      {
         cat("Invalid type. Try again\n")
         count = count - 1
      }
   )
   
   count = count + 1
}

cat("The columns will be identifed as such: \n")
print(types)

timeIndex = as.numeric(readline("Which column contains the timestamps (Do NOT count the NULL columns)?"))
splitColumn = as.numeric(readline("Which column is the column you would like to split into wide format 
Do NOT count the NULL columns)?"))     

setwd("~/Desktop/r_workspace/TestData/resources")
file = readline("Enter the name of the csv file you want to format (file must be in resources folder): ")
cat("Processing...\n")

cat("Reading csv...\n")
data = read.csv(file = file, header = TRUE, colClasses = types)
cat("Finished reading csv!\n")

cat("Initializing data frame...\n")
index = as.POSIXct(data[,timeIndex], origin = "1970-01-01", tz = "GMT")
data[,timeIndex] = index
cat("Finished initializing data frame!\n")

cat("Reshaping data frame to wide format...\n")
wdata = reshape(data, idvar = names(data[timeIndex]), timevar = names(data[splitColumn]), direction = "wide")
cat("Finished reshaping data frame to wide format!\n")

cat("Writing file to output folder...\n")
write.csv(wdata, "../output/out.csv", na = "")
cat("File written to output folder!\n")
