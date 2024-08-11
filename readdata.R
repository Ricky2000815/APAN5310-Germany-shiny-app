library(leaflet)
library(RPostgres)
library(shiny)
library(shinyalert)
library(shinythemes)
library(shinyWidgets)
library(tidyverse)
library(readxl)

con <- dbConnect(
  drv = dbDriver('Postgres'), 
  dbname = 'wc_24b_01',
  host = 'db-postgresql-nyc1-44203-do-user-8018943-0.b.db.ondigitalocean.com', 
  port = 25061,
  user = 'proj1', 
  password = 'AVNS_uXdPDeGhP-ygI0lFS3h'
)

stmt1 = 'CREATE TABLE location (
          locn_id int,
          street_address varchar(500),
          city varchar(50),
          state varchar(50),
          country varchar(50),
          zip int,
          lat numeric,
          lng numeric,
          PRIMARY KEY (locn_id));'
dbExecute(con, 'DROP TABLE IF EXISTS location CASCADE;')
dbExecute(con, stmt1)

stmt2 = 'CREATE TABLE hotel (
          hotel_id int,
          locn_id int,
          hotel_name varchar(100),
          google_map_rating numeric,
          star_rating int,
          phone bigint,
          PRIMARY KEY (hotel_id, locn_id),
          FOREIGN KEY (locn_id) REFERENCES location(locn_id));'
dbExecute(con, 'DROP TABLE IF EXISTS hotel CASCADE;')
dbExecute(con, stmt2)

stmt3 = 'CREATE TABLE restaurant (
          rest_id int,
          hotel_id int,
          locn_id int,
          rest_name varchar(100),
          type_of_food varchar(50),
          google_map_rating numeric,
          price_range varchar(50),
          PRIMARY KEY (rest_id, locn_id),
          FOREIGN KEY (locn_id) REFERENCES location(locn_id));'
dbExecute(con, 'DROP TABLE IF EXISTS restaurant CASCADE;')
dbExecute(con, stmt3)

stmt4 = 'CREATE TABLE stadium (
          stadium_id int,
          locn_id int,
          stadium_name varchar(50),
          capacity int,
          PRIMARY KEY (stadium_id, locn_id),
          FOREIGN KEY (locn_id) REFERENCES location);'
dbExecute(con, 'DROP TABLE IF EXISTS stadium CASCADE;')
dbExecute(con, stmt4)

stmt5 = 'CREATE TABLE players (
          player_id int,
          name varchar(50),
          date_of_birth date,
          age int,
          position varchar(50),
          height int,
          international_matches int,
          market_value int,
          highlight_link varchar(500),
          cloth_link varchar(500),
          PRIMARY KEY (player_id));'
dbExecute(con, 'DROP TABLE IF EXISTS players CASCADE;')
dbExecute(con, stmt5)

path = 'D:/Columbia/APAN5310/Shinyapp/Germany/germany.xlsx'
sheet_names = excel_sheets(path)
df1 = read_excel(path, sheet = 'Location')
df1 = na.omit(df1)
df2 = read_excel(path, sheet = 'Hotel')
df3 = read_excel(path, sheet = 'Restaurant')
df4 = read_excel(path, sheet = 'stadiums')
df4 = na.omit(df4)
df5 = read_excel(path, sheet = 'Players')

dbWriteTable(
  conn = con,
  name = 'location',
  value = df1,
  row.names = FALSE,
  append = TRUE
)

dbWriteTable(
  conn = con,
  name = 'hotel',
  value = df2,
  row.names = FALSE,
  append = TRUE
)

dbWriteTable(
  conn = con,
  name = 'restaurant',
  value = df3,
  row.names = FALSE,
  append = TRUE
)

dbWriteTable(
  conn = con,
  name = 'stadium',
  value = df4,
  row.names = FALSE,
  append = TRUE
)

dbWriteTable(
  conn = con,
  name = 'players',
  value = df5,
  row.names = FALSE,
  append = TRUE
)