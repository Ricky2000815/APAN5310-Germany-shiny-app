# the necessary packages
library(leaflet)
library(RPostgres)
library(shiny)
library(shinyalert)
library(shinythemes)
library(shinyWidgets)
library(tidyverse)

# connection to the wc_24b database----
# replace with your server credentials
con = dbConnect(
  drv = dbDriver('Postgres'), 
  dbname = 'wc_24b_01',
  host = 'db-postgresql-nyc1-44203-do-user-8018943-0.b.db.ondigitalocean.com', 
  port = 25061,
  user = 'proj1', 
  password = 'AVNS_uXdPDeGhP-ygI0lFS3h'
)

# teammate tibble----
teammate = tibble(
  first = c(
    'Danyu',
    'Tiranun',
    'Jade',
    'Ruiyao',
    'Xuchao',
    'Tianshu',
    'Xiaowen',
    'Shunming'
  ),
  last = c(
    'Li',
    'Ruk',
    'Liang',
    'Wang',
    'Gao',
    'Wei',
    'Shang',
    'Li'
  ),
  info = c(
    'Education: Bachelor of Quantitative Economics and Math.<br>Work Experience: Credit analyst at a bank.',
    'Education: Bachelor of Accounting, Thammasat Business School. MSc in Finance, Thammasat Business School.<br>Work Experience: Senior Examiner at the Central Bank of Thailand.',
    'Education: Bachelor of Marketing and Communication.<br>Work Experience: Marketing Specialist/Paralegal/Data Analyst @ Zenmo Law.',
    'Education: Bachelor of Science in Economics and mathematics minor at the University of Connecticut.<br>Work Experience: Data analyst intern at Alibaba and Investment and data analyst at Zhongde Securities.',
    'Education: Bachelor of Arts in Mathematics and Economics.<br>Work Experience: Treasury intern at an energy company.',
    'Education: Bachelor of Science in Economic Statistics.<br>Work Experience: Digital Consultant at Deloitte.',
    'Education: Bachelor of Economics, University of California, Santa Barbara.<br>Work Experience: GTM intern at Nio.',
    'Education: Bachelor of Applied Mathematics with Statistics and Economics.<br>Work Experience: Tax Intern at KPMG, Investment Bank Associate at Guosen Securities Co., Ltd.'
  )
)

