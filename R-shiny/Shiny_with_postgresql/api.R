library(plumber)
library(dplyr)
library(ggplot2)
library(gapminder)
library(glue)
library(leaflet)

# Importing global file
source("C:/MyFiles/Learning/git/R-Projects/R-shiny/Shiny_with_postgresql/global.R")

# Importing database connection file
source("C:/MyFiles/Learning/git/R-Projects/R-shiny/Shiny_with_postgresql/db_connect.R")

#* @apiTitle API
#* @apiDescription API for exploring dataset

#* Returns earthquakes data that satisfy condition
#* @param in_richter
#* @get /earthquakes
function(in_richter) {
  # Get the data
  data <- dbGetQuery(conn, glue("SELECT * FROM {table_name}"))
  
  # Convert to data.frame
  data.frame(data)
  
  data %>%
    filter(
      focal_depth > 0,
      richter == in_richter
    )
}

#* Returns all data
#* @get /earthquakes_all
function() {
  # Get the data
  data <- dbGetQuery(conn, glue("SELECT focal_depth, latitude, longitude, richter FROM {table_name}"))
  
  # Convert to data.frame
  data.frame(data)
}

#* Inserts earthquakes data
#* @param in_focal_depth
#* @param in_latitude
#* @param in_longitude
#* @param in_richter
#* @post /in_earthquakes
function(in_focal_depth, in_latitude, in_longitude, in_richter) {
  # Get the data
  data <- dbGetQuery(conn, glue("INSERT INTO {table_name} (focal_depth, latitude, longitude, richter) VALUES ({in_focal_depth}, {in_latitude}, {in_longitude}, {in_richter})"))
}
#* Update earthquakes data
#* @param in_earthquake_ID
#* @param in_focal_depth
#* @param in_latitude
#* @param in_longitude
#* @param in_richter
#* @post /update_earthquakes
function(in_earthquake_ID, in_focal_depth, in_latitude, in_longitude, in_richter) {
  # Get the data
  data <- dbGetQuery(conn, glue("UPDATE {table_name} SET focal_depth = {in_focal_depth}, latitude = {in_latitude}, longitude = {in_longitude}, richter = {in_richter} WHERE earthquake_ID = {in_earthquake_ID}"))
}

#* Delete earthquakes data
#* @param in_earthquake_ID
#* @post /delete_earthquakes
function(in_earthquake_ID) {
  # Get the data
  data <- dbGetQuery(conn, glue("DELETE FROM {table_name} WHERE earthquake_ID = {in_earthquake_ID}"))
}
