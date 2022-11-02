library(bigrquery)
library(dplyr)

bq_auth(path ='./oval-plate-367310-0010e61f0cbb.json')

ds <- bq_dataset("oval-plate-367310", "earthquake")

tb <- bq_dataset_query(
  x = ds,
  query = "SELECT * FROM `earthquakes`",
  billing = 'oval-plate-367310'
)
dt <- bq_table_download(tb)
dt
