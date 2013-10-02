# Description: master.R manages which R scripts are to be ran from a top level
# standpoint
#
# Author: knavero
###############################################################################

rm(list = ls())

cmd_args = commandArgs(trailingOnly = TRUE)

types = cmd_args[1:(length(cmd_args) - 3)]
timeIndex = as.numeric(cmd_args[length(cmd_args) - 2])
splitColumn = as.numeric(cmd_args[length(cmd_args) - 1])
file = cmd_args[length(cmd_args)]

source("~/Desktop/r_workspace/TestData/src/format.R")
source("~/Desktop/r_workspace/TestData/src/graph.R")

#Done