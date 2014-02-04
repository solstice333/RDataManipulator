# Description: format.R formats the test data from long format to 
# wide format based on the mac id's of the sensor with multiple records along
# a time series
#
# Author: knavero
###############################################################################

#user input within this R script. If bash shell script (the caller of this R script) 
#is intended to be ran, DEBUG is false, true otherwise. In other words, DEBUG is true when
#this script is intended to be ran individually
DEBUG = FALSE

#Reliability threshold
RELIABILITY_THRESHOLD = 12

#Loop to collect details for colClasses vector
# Example Input for data frame to have mac_id, timestamp, iwc
#    test.csv
#    1 (NULL)
#    2 (character)
#    3 (numeric)
#    3 (numeric)
#    1 (NULL)
#    d (done)
#    2 (timestamp selection)
#    1 (split mac_id)
if(DEBUG) {
   done = FALSE;
   types = vector(mode = "character")
   count = 1

   #get the name of the csv file to be formatted
   setwd("~/Desktop/r_workspace/TestData/resources")
   
   repeat {
      file = readline("Enter the name of the csv file you want to format (file must be in 'TestData/resources' folder): ")
      if (file.exists(file.path(getwd(), file)))
         break
      else
         cat("File does not exist. Try again.")  
   }
   
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
}

cat("Processing...\n")

if (!DEBUG)
   setwd("resources")

#read the csv, remove last row as a precaution
cat("Reading csv...\n")
data = read.csv(file = file, header = TRUE, colClasses = types)
data = data[1:nrow(data) - 1,]
data = data[order(data$timestamp),]
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

#create mote reliability summary (rframe stands for reliability frame)
name = character()
reliability = numeric()

for (i in 2:length(wdata)) {
   cat(paste("Testing reliability for ", names(wdata[i]), '\n'))
   rframe = na.omit(data.frame(wdata[1], wdata[i]))
   delta = c(0, diff(rframe[,1]))
   rframe = data.frame(rframe, delta)
   sub_rframe = subset(rframe, delta >= RELIABILITY_THRESHOLD)
   x = 100 - nrow(sub_rframe) / nrow(rframe) * 100
   
   name = c(name, names(rframe[2]))
   reliability = c(reliability, x)
   
   #print(sub_rframe)
   
   #write sub_rframe to output directory
   #cat("Writing file to output folder...\n")
   #write.csv(sub_rframe, paste("../output/lag", names(rframe[2]), ".csv"), na = "")
   #cat("File written to output folder (TestData/output)!\n")
}

summaryframe = data.frame(name, reliability)

#write summary to output directory
cat("Writing file to output folder...\n")
write.csv(summaryframe, "../output/summary.csv", na = "")
cat("File written to output folder (TestData/output)!\n")
cat("\n\n")

# go back to parent directory
setwd("..")
   
