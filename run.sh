#!/bin/bash

#TODO make this shell script work in that it will run the run.R script

echo "Installing r-base..."
sudo apt-get install r-base

echo "Installing zip..."
sudo apt-get install zip

true=1
false=0
quit=$false
count=1
array=()

echo "Enter the name of the csv file you want to format" 
echo -e "(file must be in "TestData/resources" folder): \c" 
read file
filepath="resources/$file"

if [ ! -f $filepath ]; then
   echo "File not found!"
   exit 1
   
fi

echo ""

echo -e "\nEach column of the data frame must be associated with a data type. Type description:"
echo "   1) 'NULL' type will remove a column from the data frame"
echo "   2) 'character' type will represent a string"
echo "   3) 'numeric' type will represent a number with double precision"
echo ""

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
   echo ""
done

echo "The columns will be identified as such: "
echo -e ${array[*]} "\n"

echo -e "Which column contains the timestamps (Do NOT count the NULL columns)?: \c"
read timeIndex
echo ""

echo "Which column is the column you would like to split into wide format" 
echo -e "(Do NOT count the NULL columns)? \c"
read splitColumn
echo ""

R --vanilla --silent --args ${array[*]} $timeIndex $splitColumn $file < src/master.R

zip -r output/output.zip output/*
