library(DBI)
library(RSQLite)
library(RMySQL)

# Connect to MySQL database
mysql_conn <- dbConnect(RMySQL::MySQL(), 
                        host = "sql8.freemysqlhosting.net", 
                        user = "sql8636624", 
                        password = "QSWKpaY4w7",
                        dbname = "sql8636624")

# Connect to SQLite database
sqlite_conn <- dbConnect(RSQLite::SQLite(), "pharma_db.sqlite")


dbExecute(mysql_conn, "DROP TABLE IF EXISTS product_facts;")
dbExecute(mysql_conn, "DROP TABLE IF EXISTS rep_facts;")

# Create product_facts table
dbExecute(mysql_conn, "CREATE TABLE product_facts (
  productID INTEGER,
  productName TEXT NOT NULL,
  totalSold INTEGER,
  year INTEGER,
  quarter INTEGER,
  region VARCHAR(255) NOT NULL,
  PRIMARY KEY(productID, year, quarter, region)
)")


# Create rep_facts table
dbExecute(mysql_conn, "CREATE TABLE rep_facts (
  repID INTEGER,
  repfirstName TEXT NOT NULL,
  replastName TEXT NOT NULL,
  region VARCHAR(255) NOT NULL,
  totalSold INTEGER,
  year INTEGER,
  quarter INTEGER,
  productID INTEGER,
  PRIMARY KEY(repID, year, quarter, productID)
)")


# Query to populate product_facts from SQLite


product_query <- "
  SELECT p.productID, p.productName, SUM(s.amount) AS totalSold,
         substr(s.date, -4) AS year,
         CASE 
           WHEN CAST(substr(s.date, 1, instr(s.date, '/') - 1) AS INTEGER) BETWEEN 1 AND 3 THEN 1
           WHEN CAST(substr(s.date, 1, instr(s.date, '/') - 1) AS INTEGER) BETWEEN 4 AND 6 THEN 2
           WHEN CAST(substr(s.date, 1, instr(s.date, '/') - 1) AS INTEGER) BETWEEN 7 AND 9 THEN 3
           WHEN CAST(substr(s.date, 1, instr(s.date, '/') - 1) AS INTEGER) BETWEEN 10 AND 12 THEN 4
         END AS quarter,
         r.territory AS region
  FROM salestxn s
  JOIN products p ON s.productID = p.productID
  JOIN reps r ON s.repID = r.repID
  GROUP BY p.productID, year, quarter, r.territory
"


# Fetch product_facts data from SQLite
product_facts <- dbGetQuery(sqlite_conn, product_query)

# print(product_facts)

# Insert product_facts data into MySQL
dbWriteTable(mysql_conn, name = "product_facts", value = product_facts, row.names = FALSE, append = TRUE)



rep_query <- "
  SELECT r.repID, r.firstName AS repfirstName, r.lastName AS replastName, r.territory AS region, SUM(s.amount) AS totalSold,
         substr(s.date, -4) AS year,
         CASE 
           WHEN CAST(substr(s.date, 1, instr(s.date, '/') - 1) AS INTEGER) BETWEEN 1 AND 3 THEN 1
           WHEN CAST(substr(s.date, 1, instr(s.date, '/') - 1) AS INTEGER) BETWEEN 4 AND 6 THEN 2
           WHEN CAST(substr(s.date, 1, instr(s.date, '/') - 1) AS INTEGER) BETWEEN 7 AND 9 THEN 3
           WHEN CAST(substr(s.date, 1, instr(s.date, '/') - 1) AS INTEGER) BETWEEN 10 AND 12 THEN 4
         END AS quarter,
         p.productID
  FROM salestxn s
  JOIN reps r ON s.repID = r.repID
  JOIN products p ON s.productID = p.productID
  GROUP BY r.repID, year, quarter, p.productID
"

# Fetch rep_facts data from SQLite
rep_facts <- dbGetQuery(sqlite_conn, rep_query)

# print(rep_facts)

# Insert rep_facts data into MySQL
dbWriteTable(mysql_conn, name = "rep_facts", value = rep_facts, row.names = FALSE, append = TRUE)



reps <- dbGetQuery(mysql_conn, "SELECT * FROM rep_facts;")
prod <- dbGetQuery(mysql_conn, "SELECT * FROM product_facts;")


print(head(reps, 20))
print(head(prod, 20))

print(tail(reps, 10))
print(tail(prod, 10))


## What is the total sold for each quarter of 2022 for all products?

total_sold_2022_query <- "
  SELECT quarter, SUM(totalSold) AS totalSales
  FROM product_facts
  WHERE year = 2020
  GROUP BY quarter;
"
total_sold_2022 <- dbGetQuery(mysql_conn, total_sold_2022_query)
print(total_sold_2022)


## What is the total sold for each quarter of 2021 for 'Alaraphosol'?

total_sold_alaraphosol_query <- "
  SELECT quarter, SUM(totalSold) AS totalSales
  FROM product_facts
  WHERE year = 2020 AND productName = 'Alaraphosol'
  GROUP BY quarter;
"
total_sold_alaraphosol <- dbGetQuery(mysql_conn, total_sold_alaraphosol_query)
print(total_sold_alaraphosol)


## Which product sold the best in 2022?

best_product_2022_query <- "
  SELECT productName, SUM(totalSold) AS totalSales
  FROM product_facts
  WHERE year = 2020
  GROUP BY productName
  ORDER BY totalSales DESC
  LIMIT 1;
"
best_product_2022 <- dbGetQuery(mysql_conn, best_product_2022_query)
print(best_product_2022)


## How much did each sales rep sell in 2022?

sales_rep_2022_query <- "
  SELECT repID, repfirstName, replastName, SUM(totalSold) AS totalSales
  FROM rep_facts
  WHERE year = 2020
  GROUP BY repID, repfirstName, replastName;
"
sales_rep_2022 <- dbGetQuery(mysql_conn, sales_rep_2022_query)
print(sales_rep_2022)

## Who Sold the Most Products in EMEA in 2022?

top_seller_EMEA_2022_query <- "
  SELECT r.repID, r.repfirstName, r.replastName, SUM(r.totalSold) AS totalSales
  FROM rep_facts r
  WHERE r.year = 2020 AND r.region = 'EMEA'
  GROUP BY r.repID, r.repfirstName, r.replastName
  ORDER BY totalSales DESC
  LIMIT 1;
"
top_seller_EMEA_2022 <- dbGetQuery(mysql_conn, top_seller_EMEA_2022_query)
print(top_seller_EMEA_2022)


# Disconnect from databases
dbDisconnect(mysql_conn)
dbDisconnect(sqlite_conn)

