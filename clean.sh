#!/bin/bash

# Description: clean.sh is for the user to clear the Output directory from a high level
# in order to prevent accidental deletion of anything else in the repository

if [ -e output/out.csv -o -e output/overlay.png -o -e output/summary.csv -o -e output/output.zip ]; then 
   rm output/*
   echo "Output directory cleaned!"
else 
   echo "Output directory is already clean!"
fi

