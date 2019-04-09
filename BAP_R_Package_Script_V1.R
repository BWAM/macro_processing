# NYSDEC Stream Biomonitoring Unit
# 
# BAP Package Script
# 
# Provides the ability to run all BAP package metric functions in R directly by connecting to the package repository on BitBucket
# This package will run 1) Riffle/Kick Sample BAP 2) Net Jab/Sandy Streams Sample BAP 3) Multiplate Navigable River Sample BAP
# 4) Multiplate Non-Navigable River Sample BAP and 5) Ponar Sample BAP 
# This includes all the individual metrics as well as needed
# 
# This script created on 10/12/16
#
# BAP Package Created by Zach Smith, last updated 10/11/16 

######### Set Working Directory ##########
# 
# This will be the folder that files are imported from and exported to.
# ***YOU WILL NEED TO CHANGE THE DIRECTORY***
#setwd("C:/NYBackup/database/Rtemplate/R_BAP_Package/RpackageTests")

######## Import the Package ##########
# devtools must be installed
# This will connect R directly to the BAP package repository on BitBucket and allow the different functions of the BAP 
# package to run, using the latest updates
library(devtools)
devtools::install_bitbucket(repo = "zsmith/NYSDEC.BAP")
# devtools::install_github(repo = "zsmith27/BAP")

######## Load the BAP library of functions ##########
library(BAP)

######## Calls on tables contained in the package #########
data("pma.model")
data("pma.ponar")
data("isd.df")
data("master")

######## Import the Taxa Data ##########
#***YOU NEED TO UPDATE THE FILE NAME, THIS SHOULD BE LOCATED IN YOUR WORKING DIRECTORY***
setwd("C:/NYBackup/RStats/Projects/RIBS/Ramapo")

#read raw species table in proper format
taxa.df <- read.csv("RAMAPO_RAS_KICKS_2018.csv")

# This function prepares the data for tbhe assessment
#***YOU DO NOT NEED TO ALTER THIS***
long.df <- data_prep(taxa.df)

######## The following functions will run the individual BAPs and their component metrics ############
# Select the BAP you wish to run based on collection method and comment out the others
# otherwise the package will run each of the BAP

#### Riffle BAP
 bap.riffle <- bap_riffle(long.df)

## ISD calculation - not verified yet as of 4-12-18

final.df<-calc.isd(long.df,isd.df) #calc ISDs
final.df$max<-apply(final.df,1,max) #add max value column
#add max ISD category name
ISDcalcs<-cbind(final.df,do.call(rbind,apply(final.df,1,function(x)
  {data.frame(ISD=names(final.df)[which.max(x)],stringsAsFactors=FALSE)})))

#### Jab BAP
# bap.jab <- bap_jab(long.df)

#### MP Navigable Waters BAP
# bap.mp.nav.waters <- bap_mp_nav_waters(long.df)

#### MP Non-Navigable Waters BAP
# bap.mp.non.nav.waters <- bap_mp_non_nav_water(long.df)

#### Ponar BAP
# bap.ponar <- bap_ponar(long.df)

######### Use the function below to export your file #########
#***YOU NEED TO CHANGE THE NAME OF THE OUTPUT .CSV FILE***
write.csv(ISDcalcs, "RamapoISD.csv")
#write.csv(bap.riffle, "2016.BAP.scores.csv")


#tidy up. This removes everything stored in short term memory
rm(list=ls())



