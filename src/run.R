# Description: run.R manages which R scripts are to be ran from a top level
# standpoint
#
# TODO: make it so that a unix shell script will automate the opening of an 
#  R console and send in an argument that adjusts the working directory to
#  as needed. Probably get the string from pwd and pass it in with commandArgs()?
#
# Author: knavero
###############################################################################

rm(list = ls())

cmd_args = commandArgs(trailingOnly = TRUE)

print(cmd_args)

#source("~/Desktop/r_workspace/TestData/src/format.R")
#source("~/Desktop/r_workspace/TestData/src/graph.R")
print("Done!")
