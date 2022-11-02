library(DBI)

db <- "earthquakes"
db_host <- "localhost"
db_port <- "5432"
db_user <- "postgres"
db_pass <- "root"

conn <- dbConnect(
  RPostgres::Postgres(),
  dbname = db,
  host = db_host,
  port = db_port,
  user = db_user,
  password = db_pass
)