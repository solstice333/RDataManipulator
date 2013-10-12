# Description: format.R formats the test data from long format to 
# wide format based on the mac id's of the sensor with multiple records along
# a time series
#
# TODO check network log data integrity (compare with sampling rate of pressure log). 
# Should be 1 sample per 10 seconds.
#
# TODO Additional overlay graphs with all new functional motes
# Duration: Single day, occupied hours
# Dates: Aug 6 and Aug 7
#
# Author: knavero
###############################################################################

#user input within this R script. If bash shell script (the caller of this R script) 
#is intended to be ran, DEBUG is false, true otherwise. In other words, DEBUG is true when
#this script is intended to be ran individually
DEBUG = TRUE

#Loop to collect details for colClasses vector
if(DEBUG) {
   done = FALSE;
   types = vector(mode = "character")
   count = 1

   cat("Each column of the data frame must be associated with a data type. Type description:\n")
   cat("   1) 'NULL' type will remove a column from the data frame\n")
   cat("   2) 'character' type will represent a string\n")
   cat("   3) 'numeric' type will represent a number with double precision\n")
   cat("\n")
   
   while(!done) {
      cat("(1) NULL\n") 
      cat("(2) character\n") 
      cat("(3) numeric\n") 
      cat("(d) done\n")

      value = readline(paste("Column ", count, ". Enter a type: "))
   
      switch (value, 
         "1" = { 
            cat(paste("NULL", '\n'))
            types = c(types, "NULL")
         },
         
         "2" = {
            cat(paste("character", '\n'))
            types = c(types, "character")
         },
         
         "3" = {
            cat(paste("numeric", '\n'))
            types = c(types, "numeric")
         },
         
         "d" = {
            done = TRUE
         },
         
         {
            cat(paste("\n", value, " is an invalid type. Try again\n"))
            count = count - 1
         }
      )
   
      count = count + 1
   }

   cat("The columns will be identifed as such: \n")
   print(types)

   #get the column that holds the timestamps and the column that holds the names to be split into wide format
   timeIndex = as.numeric(readline("Which column contains the timestamps (Do NOT count the NULL columns)?"))
   splitColumn = as.numeric(readline("Which column is the column you would like to split into wide format 
   Do NOT count the NULL columns)?")) 

   #get the name of the csv file to be formatted
   setwd("~/Desktop/r_workspace/TestData/resources")
   file = readline("Enter the name of the csv file you want to format (file must be in 'TestData/resources' folder): ")
}

cat("Processing...\n")

if (!DEBUG)
   setwd("resources")

#read the csv, remove last row as a precaution
cat("Reading csv...\n")
data = read.csv(file = file, header = TRUE, colClasses = types)
data = data[1:nrow(data) - 1,]
cat("Finished reading csv!\n")

#convert the time index to POSIXct (time index input must be numerical/signed integer)
cat("Initializing data frame...\n")
index_gmt = as.POSIXct(data[,timeIndex], origin = "1970-01-01", tz = "GMT")
index = index_pt = as.POSIXct(format(index_gmt, tz = "America/Los_Angeles"));
data[,timeIndex] = index
cat("Finished initializing data frame!\n")

#reshape the data frame to wide format
cat("Reshaping data frame to wide format...\n")
wdata = reshape(data, idvar = names(data[timeIndex]), timevar = names(data[splitColumn]), direction = "wide")
cat("Finished reshaping data frame to wide format!\n")

#write to output directory
cat("Writing file to output folder...\n")
write.csv(wdata, "../output/out.csv", na = "")
cat("File written to output folder (TestData/output)!\n")
cat("\n\n")
