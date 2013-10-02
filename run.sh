#!/bin/bash

#TODO make this shell script work in that it will run the run.R script

true=1
false=0
quit=$false
count=1
array=()

echo "Type description:"
echo "   1) 'NULL' type will remove a column from the data frame"
echo "   2) 'character' type will represent a string"
echo "   3) 'numeric' type will represent a number with double precision"

while [ $quit -eq 0 ]; do
   echo "Column $count. Enter a type name:" 
   echo "(1) NULL" 
   echo "(2) character" 
   echo "(3) numeric" 
   echo "(d) done"
     
   read value
   
   case $value in
      1) echo "NULL"
         array[$((count-1))]="NULL";;
      
      2) echo "character"
         array[$((count-1))]="character";;
      
      3) echo "numeric"
         array[$((count-1))]="numeric";;
      
      d) quit=$true;;
      
      *) echo "Invalid type. Try again"
         ((count--));;
   esac
   
   ((count++))
   echo " "
done

echo ${array[*]}
