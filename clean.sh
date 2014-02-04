#!/bin/bash

# Description: clean.sh is for the user to clear the Output directory from a high level
# in order to prevent accidental deletion of anything else in the repository

if [ $(find output -empty) ]; then
   echo "Output directory is already clean!"
else 
   rm output/*
   echo "Output directory cleaned!"
fi

