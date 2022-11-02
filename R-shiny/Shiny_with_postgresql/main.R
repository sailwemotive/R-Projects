library(shiny)
library(ggplot2)
library(dplyr)
library(DT)

# Importing global file
source("./global.R")

runApp("App-1")

runApp("App-2")


#* @AppDescription App for configuring postgresql in r shiny

library(glue)
library(leaflet)

library(httr)
library(jsonlite)
library(callr)

source("./db_connect.R")

runApp("App-3")


#* @AppDescription App for configuring bigquery in r shiny

library(bigrquery)
runApp("App-4")