# Gaurav
# CS5200 Summer 2023
# Query Tabular Data



# Import the required packages

if (!require(RSQLite)) {
  install.packages("RSQLite")
}
if (!require(sqldf)) {
  install.packages("sqldf")
}
if (!require(readr)) {
  install.packages("readr")
}
if (!require(knitr)) {
  install.packages("knitr")
}
if (!require(stringr)) {
  install.packages("stringr")
}


library(RSQLite)
library(sqldf)
library(readr)
library(knitr)
library(stringr)



# Load data from the three CSV files
data1 <- read_csv("https://s3.us-east-2.amazonaws.com/artificium.us/assignments/80.xml/a-80-305/gen-xml/synthsalestxns-Jan2Mar.csv") # replace with the actual URL of the first CSV file
data2 <- read_csv("https://s3.us-east-2.amazonaws.com/artificium.us/assignments/80.xml/a-80-305/gen-xml/synthsalestxns-Sep2Oct.csv") # replace with the actual URL of the second CSV file
data3 <- read_csv("https://s3.us-east-2.amazonaws.com/artificium.us/assignments/80.xml/a-80-305/gen-xml/synthsalestxns-Nov2Dec.csv") # replace with the actual URL of the third CSV file

# Bind the three data frames into one
data <- rbind(data1, data2, data3)
# remove the dollar sign from the 'amount' column
data$amount <- as.numeric(str_replace(data$amount, "\\$", ""))

# Run the SQL query using sqldf
restaurant_data <- sqldf("
  SELECT
    restaurant,
    COUNT(name) AS total_visits,
    '$' || ROUND(SUM(amount), 2) AS total_revenue
  FROM
    data
  GROUP BY
    restaurant")


# Print the data using kable
kable(restaurant_data)
