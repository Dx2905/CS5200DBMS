library(DBI)
library(XML)
library(RSQLite)

# Connect to SQLite database
conn <- dbConnect(RSQLite::SQLite(), "pharma_db.sqlite")

# Create products table
dbExecute(conn, "DROP TABLE IF EXISTS products;")
dbExecute(conn, "DROP TABLE IF EXISTS reps;")
dbExecute(conn, "DROP TABLE IF EXISTS customers;")
dbExecute(conn, "DROP TABLE IF EXISTS salestxn;")

# Create products table
dbExecute(conn, "CREATE TABLE products (
    productID INTEGER PRIMARY KEY AUTOINCREMENT,
    productName TEXT NOT NULL
)")


dbExecute(conn, "CREATE TABLE reps (
    repID INTEGER PRIMARY KEY,
    firstName TEXT NOT NULL,
    lastName TEXT NOT NULL,
    territory TEXT NOT NULL
)")

# Create customers table
dbExecute(conn, "CREATE TABLE customers (
    customerID INTEGER PRIMARY KEY AUTOINCREMENT,
    customerName TEXT NOT NULL,
    country TEXT NOT NULL
)")

# Create salestxn table
dbExecute(conn, "CREATE TABLE salestxn (
    txnID INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT NOT NULL,
    customerID INTEGER,
    productID INTEGER,
    qty INTEGER,
    amount REAL,
    repID INTEGER,
    FOREIGN KEY (customerID) REFERENCES customers(customerID),
    FOREIGN KEY (productID) REFERENCES products(productID),
    FOREIGN KEY (repID) REFERENCES reps(repID)
)")


# Load pharmaReps.xml
xml_reps <- xmlParse("txn-xml/pharmaReps.xml", valid = TRUE)


reps_nodes <- getNodeSet(xml_reps, "//rep")
reps_data <- do.call(rbind, lapply(reps_nodes, function(x) {
  rID_value <- as.character(xmlGetAttr(x, "rID"))
  repID <- as.integer(substr(rID_value, 2, nchar(rID_value)))
  firstName <- as.character(xmlValue(x[["firstName"]]))
  lastName <- as.character(xmlValue(x[["lastName"]]))
  territory <- as.character(xmlValue(x[["territory"]]))
  data.frame(
    repID = repID,
    firstName = firstName,
    lastName = lastName,
    territory = territory,
    stringsAsFactors = FALSE
  )
}))

# Write the reps_data to the reps table in the database
dbWriteTable(conn, name = "reps", value = reps_data, row.names = FALSE, overwrite = TRUE)


  
list.files(path = "txn-xml")

# txn_files <- list.files(path = "txn-xml", pattern = "pharmaSalesTxn*.xml", full.names = TRUE)
txn_files <- list.files(path = "txn-xml", pattern = "pharmaSalesTxn.*\\.xml$", full.names = TRUE)
print(txn_files)

for (file in txn_files) {


  print(file)
  # xml_txn <- xmlParse("txn-xml/pharmaSalesTxn-20-A.xml")
  xml_txn <- xmlParse(file, valid = TRUE)
  txn_nodes <- getNodeSet(xml_txn, "//txn")
  for (txn_node in txn_nodes) {
    txnID <- as.integer(xmlValue(txn_node[["txnID"]]))
    date <- as.character(xmlValue(txn_node[["date"]]))
    cust <- as.character(xmlValue(txn_node[["cust"]]))
    prod <- as.character(xmlValue(txn_node[["prod"]]))
    qty <- as.integer(xmlValue(txn_node[["qty"]]))
    amount <- as.numeric(xmlValue(txn_node[["amount"]]))
    country <- as.character(xmlValue(txn_node[["country"]]))
    repID <- as.integer(xmlValue(txn_node[["repID"]]))
    
    # print(paste("Processing:", txnID, date, cust, prod, qty, amount, country, repID))
    
    # Insert into customers and products tables if necessary
    customerID <- dbGetQuery(conn, paste0("SELECT customerID FROM customers WHERE customerName = '", cust, "' AND country = '", country, "'"))$customerID
    if (is.na(customerID) || length(customerID) == 0) {
      query <- paste0("INSERT INTO customers (customerName, country) VALUES ('", cust, "', '", country, "')")
      # print(query)
      dbExecute(conn, query)
      customerID <- dbGetQuery(conn, "SELECT last_insert_rowid() AS id")$id
    }
    
    productID <- dbGetQuery(conn, paste0("SELECT productID FROM products WHERE productName = '", prod, "'"))$productID
    if (is.na(productID) || length(productID) == 0) {
      query <- paste0("INSERT INTO products (productName) VALUES ('", prod, "')")
      # print(query)
      dbExecute(conn, query)
      productID <- dbGetQuery(conn, "SELECT last_insert_rowid() AS id")$id
    }
    
    query <- paste0("INSERT INTO salestxn ( date, customerID, productID, qty, amount, repID) VALUES ('", date, "', ", customerID, ", ", productID, ", ", qty, ", ", amount, ", ", repID, ")")
    # print(query)
    dbExecute(conn, query)
  }
}


dbDisconnect(conn)


con <- dbConnect(RSQLite::SQLite(), dbname = "pharma_db.sqlite")
reps <- dbGetQuery(con, "SELECT * FROM reps;")
cust <- dbGetQuery(con, "SELECT * FROM customers;")
prod <- dbGetQuery(con, "SELECT * FROM products;")
salestxn <- dbGetQuery(con, "SELECT * FROM salestxn;")
dbDisconnect(con)

# Print the data (optional)
print(head(reps, 20))
print(head(cust, 20))
print(head(prod, 20))
print(head(salestxn, 20))
print(tail(salestxn, 20))



