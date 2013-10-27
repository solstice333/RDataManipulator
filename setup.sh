#!/bin/bash

# Description: setup.sh is for the user to install the dependencies and setup the program
# so that run.sh can be used

sudo apt-get install r-base
sudo apt-get install zip
R --vanilla --silent < src/setup.R
