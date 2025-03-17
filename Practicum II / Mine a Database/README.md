# Data Extraction and Database Management

## 📌 Project Overview
This project focuses on **extracting, transforming, and managing data** from XML sources into **SQLite and MySQL databases**. It consists of two primary components:
- **Parsing and Loading XML Data into SQLite** (handled in `LoadXML2DB.Gaurav.R`)
- **Transforming and Storing Data into MySQL for Data Warehousing** (handled in `LoadDataWarehouse.Gaurav.R`)

The project is particularly useful for structuring and analyzing **pharmaceutical sales transactions**, including product details, sales representatives, customers, and financial transactions.

---

## 📜 Table of Contents
- [Project Overview](#project-overview)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Usage](#usage)
- [Project Files](#project-files)
- [Results & Insights](#results--insights)
- [Future Enhancements](#future-enhancements)
- [Contributors](#contributors)
- [License](#license)

---

## 🚀 Features
- **XML Data Extraction**: Parses `pharmaReps.xml` and `pharmaSalesTxn*.xml` to extract structured data.
- **Database Creation**: Sets up **SQLite** and **MySQL** databases for structured storage.
- **Data Transformation**: Converts raw XML data into normalized tables.
- **Query Execution**: Retrieves aggregated sales insights using SQL queries.
- **Data Warehousing**: Transfers processed data into MySQL for further analysis.

---

## 💡 Technologies Used
- **Programming Language**: R
- **Libraries**:
  - `DBI`, `RSQLite` - SQLite Database Management
  - `RMySQL` - MySQL Database Interaction
  - `XML` - Parsing XML Data
- **Databases**:
  - **SQLite** (Local storage for raw transactions)
  - **MySQL** (Data warehouse for structured analytics)

---

## 🛠 Installation
To set up the project on your system, follow these steps:

1. **Install R and Required Packages**:
   ```r
   install.packages("DBI")
   install.packages("RSQLite")
   install.packages("RMySQL")
   install.packages("XML")
   ```
2. **Clone the Repository**:
   ```bash
   git clone https://github.com/Dx2905/CS5100-Foundation-Of-AI.git
   cd CS5100-Foundation-Of-AI/Project/Bloom's Taxonomy Classification
   ```
3. **Ensure MySQL is Running**:
   - Modify `LoadDataWarehouse.Gaurav.R` with **your MySQL credentials**.
   - Update the host, user, password, and database name.

---

## 🎯 Usage
### **Step 1: Load XML Data into SQLite**
Run the following command to parse XML files and insert data into SQLite:
```r
source("LoadXML2DB.Gaurav.R")
```
This script:
- Reads XML files (`pharmaReps.xml`, `pharmaSalesTxn-*.xml`)
- Creates **products, reps, customers, and transactions** tables in SQLite
- Loads extracted data into the database

### **Step 2: Transform & Load Data into MySQL**
Run:
```r
source("LoadDataWarehouse.Gaurav.R")
```
This script:
- Extracts processed data from SQLite
- Transforms it into structured **fact tables** (`product_facts`, `rep_facts`)
- Loads the transformed data into a **MySQL database** for analysis

---

## 📂 Project Files
| File Name | Description |
|-----------|------------|
| `LoadXML2DB.Gaurav.R` | Parses XML files and stores data in SQLite |
| `LoadDataWarehouse.Gaurav.R` | Transfers SQLite data to MySQL and runs queries |
| `pharmaReps.xml` | XML file containing sales representatives data |
| `pharmaSalesTxn-*.xml` | Transactional sales data files |

---

## 📊 Results & Insights
Once the data is processed, we can execute SQL queries to gain insights:
1. **Total Sales Per Quarter in 2022**
   ```sql
   SELECT quarter, SUM(totalSold) AS totalSales FROM product_facts WHERE year = 2022 GROUP BY quarter;
   ```
2. **Best-Selling Product in 2022**
   ```sql
   SELECT productName, SUM(totalSold) AS totalSales FROM product_facts WHERE year = 2022 GROUP BY productName ORDER BY totalSales DESC LIMIT 1;
   ```
3. **Top Sales Rep in EMEA (2022)**
   ```sql
   SELECT repID, repfirstName, replastName, SUM(totalSold) AS totalSales FROM rep_facts WHERE year = 2022 AND region = 'EMEA' GROUP BY repID ORDER BY totalSales DESC LIMIT 1;
   ```

These queries help analyze **sales trends, best performers, and regional performance**.

---

## 🔮 Future Enhancements
- **Automate Data Updates**: Implement a cron job or scheduled task to update the database periodically.
- **Enhance Query Optimization**: Use indexing and normalization to improve MySQL query performance.
- **Implement a Web Dashboard**: Visualize sales trends using **Tableau, Power BI, or Shiny**.
- **API Integration**: Expose key insights via a REST API.

---

## 👥 Contributors
- **Gaurav** ([@Dx2905](https://github.com/Dx2905))

📍 **Khoury College, Northeastern University, Portland, Maine, USA**

For inquiries, contact: `lnu.gau@northeastern.edu`

---

## 📜 License
This project is licensed under the **MIT License**. See the [LICENSE](https://github.com/Dx2905/CS5100-Foundation-Of-AI/blob/main/LICENSE) file for more details.

---

🚀 **If you found this project useful, give it a ⭐ on GitHub!** 🎉

