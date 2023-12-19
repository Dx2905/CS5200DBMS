

# TransactionGroup6.CS5200.SuF.Txn.R

# R Program Header Comments:
# Author: Transaction Group 6
# Course: CS5200
# Semester: Summer
# Purpose: Perform transactions on a cloud MySQL database

# Load the necessary packages
install.packages("RMySQL")
library(RMySQL)

# Connect to the MySQL database
con <- dbConnect(MySQL(), 
                 user = "sql8628033",
                 password = "qSWxNVaMtl",
                 dbname = "sql8628033",
                 host = "sql8.freemysqlhosting.net")


# Check if the connection was successful
if (dbIsValid(con)) {
  cat("Connection to MySQL database established successfully!")
} else {
  cat("Failed to connect to the MySQL database.")
}


# Create a dataframe with ten bird strike incidents
bird_strikes <- data.frame(
  rid = c(202152, 202153, 202154, 202155, 202156,
          202157, 202158, 202159, 202160, 202161),
  aircraft = c("Airplane", "Airplane", "Airplane", "Airplane", "Airplane",
               "Airplane", "Airplane", "Airplane", "Airplane", "Airplane"),
  airport = c("LAGUARDIA NY", "Newyork", "Newyork", "Atlanta", "Texas",
              "Boston", "LA", "NewJersey", "LAGUARDIA NY", "Texas"),
  model = c("B-737-400", "B-737-400", "MD-80", "A-300", "A-320",
            "C-421", "DC-9-50", "C-421", "B-737", "B-737"),
  wildlife_struck = c(859, 13, 45, 8, 9, 76, 17, 12, 5, 15),
  impact = c("Engine Shut Down", "None", "None", "Engine Shut Down", "Engine Shut Down",
             "Aborted Take-off", "None", "None", "None", "Engine Shut Down"),
  flight_date = c("11/23/2000 0:00", "11/24/2000 0:00", "11/25/2000 0:00", "11/26/2000 0:00", "11/27/2000 0:00",
                  "11/28/2000 0:00", "11/29/2000 0:00", "11/30/2000 0:00", "12/01/2000 0:00", "12/02/2000 0:00"),
  damage = c("Caused damage", "No damage", "No damage", "Caused damage", "Caused damage",
             "Caused damage", "No damage", "Caused damage", "No damage", "Caused damage"),
  airline = c("US AIRWAYS*", "US AIRWAYS*", "US AIRWAYS*", "US AIRWAYS*", "US AIRWAYS*",
              "Air pacific", "Air good", "US american", "Air atlantic", "Air great"),
  origin = c("South Carolina", "South Carolina", "South Carolina", "South Carolina", "South Carolina",
             "New York", "New York", "New York", "New York", "New York"),
  flight_phase = c("Climb", "Approach", "Climb", "Climb", "Climb",
                   "Climb", "Approach", "Approach", "Approach", "Climb"),
  remains_collected_flag = c("FALSE", "FALSE", "FALSE", "FALSE", "FALSE",
                             "FALSE", "FALSE", "FALSE", "FALSE", "FALSE"),
  remarks = c("FLT 753. PILOT REPTD A HUNDRED BIRDS ON UNKN TYPE. #1 ENG WAS SHUT DOWN AND DIVERTED TO EWR. SLIGHT VIBRATION. A/C WAS OUT OF SVC FOR REPAIRS TO COWLING, FAN DUCT ACCOUSTIC PANEL. INGESTION. DENTED FAN BLADE #26 IN #1 ENG. HEAVY BLOOD STAINS ON L WINGTIP",
              "Remarks 2", "Remarks 3", "Remarks 4", "Remarks 5",
              "Remarks 6", "Remarks 7", "Remarks 8", "Remarks 9", "Remarks 10"),
  wildlife_size = c("Medium", "Medium", "Medium", "Medium", "Medium",
                    "Medium", "Medium", "Medium", "Medium", "Medium"),
  sky_conditions = c("No Cloud", "No Cloud", "Some Cloud", "No Cloud", "No Cloud",
                     "No Cloud", "Some Cloud", "Some Cloud", "Some Cloud", "No Cloud"),
  species = c("Unknown bird - medium", "Unknown bird - medium", "Unknown bird - medium", "Unknown bird - medium", "Unknown bird - medium",
              "Unknown bird - medium", "Unknown bird - medium", "Unknown bird - medium", "Unknown bird - medium", "Unknown bird - medium"),
  pilot_warned_flag = c("N", "Y", "N", "N", "N",
                        "N", "Y", "Y", "Y", "N"),
  altitude_ft = c(1500, 2300, 2345, 1400, 1300,
                  1295, 1187, 1176, 900, 300),
  heavy_flag = c("Yes", "No", "Yes", "Yes", "No",
                 "Yes", "No", "No", "Yes", "No")
)

# Save the dataframe as a CSV file
write.csv(bird_strikes, "bird_strikes.csv", row.names = FALSE)

### MINE start

# # Get the table names
# tables <- dbListTables(con)
# 
# # Display the schema for each table
# for (table in tables) {
#   # Fetch the column names and types
#   result <- dbGetQuery(con, paste("DESCRIBE", table))
#   
#   # Print the table name
#   cat("Table:", table, "\n")
#   
#   # Print the column names and types
#   cat("Column Name\tType\n")
#   cat("-----------------\t--------\n")
#   for (row in 1:nrow(result)) {
#     cat(result[row, "Field"], "\t\t", result[row, "Type"], "\n")
#   }
#   
#   cat("\n")
# }
# 
# # Perform transactions on the database
# 
# load_csv_to_database <- function(csv_file, db_connection) {
#   # Read CSV file
#   csv_data <- read.csv(csv_file)
# 
# try({
#   # insert data into database
#   # Loop through each row in the CSV data and insert into the database
#   for (i in 1:nrow(csv_data)) {
#     # Get the values from the current row
#     i_airport_state <- csv_data[i, "Airport state"]
#     i_sky_condition <- csv_data[i, "sky condition"]
#     i_date <- as.Date(csv_data[i, "date"], format = "%Y-%m-%d")
#     i_airline <- csv_data[i, "airline"]
#     i_aircraft <- csv_data[i, "aircraft"]
#     i_altitude <- as.integer(csv_data[i, "altitude"])
#     i_heavy <- as.integer(csv_data[i, "heavy"])
#     i_numbirds <- as.integer(csv_data[i, "numbirds"])
#     i_impact <- csv_data[i, "impact"]
#     i_damage <- as.integer(csv_data[i, "damage"])
#     
#     # Prepare the SQL statement for calling the stored procedure
#     sql <- paste("CALL AddNewStrike('", i_airport_state, "', '", i_sky_condition, "', '",
#                  i_date, "', '", i_airline, "', '", i_aircraft, "', ", i_altitude, ", ",
#                  i_heavy, ", ", i_numbirds, ", '", i_impact, "', ", i_damage, ")", sep = "")
#     
#     # Execute the SQL statement
#     dbExecute(db_connection, sql)
#   }
#   
#   # if everything is successful, then...
#   dbCommit(db_connection)  # commit the transaction
# }, silent = FALSE, finally = {
#   # if an error occurred before dbCommit, then rollback the transaction
#   dbRollback(db_connection)
# })
# 
# 
# 
#   
#   # Loop through each row in the CSV data and insert into the database
#   for (i in 1:nrow(csv_data)) {
#     # Get the values from the current row
#     i_airport_state <- csv_data[i, "Airport state"]
#     i_sky_condition <- csv_data[i, "sky condition"]
#     i_date <- as.Date(csv_data[i, "date"], format = "%Y-%m-%d")
#     i_airline <- csv_data[i, "airline"]
#     i_aircraft <- csv_data[i, "aircraft"]
#     i_altitude <- as.integer(csv_data[i, "altitude"])
#     i_heavy <- as.integer(csv_data[i, "heavy"])
#     i_numbirds <- as.integer(csv_data[i, "numbirds"])
#     i_impact <- csv_data[i, "impact"]
#     i_damage <- as.integer(csv_data[i, "damage"])
#     
#     # Prepare the SQL statement for calling the stored procedure
#     sql <- paste("CALL AddNewStrike('", i_airport_state, "', '", i_sky_condition, "', '",
#                  i_date, "', '", i_airline, "', '", i_aircraft, "', ", i_altitude, ", ",
#                  i_heavy, ", ", i_numbirds, ", '", i_impact, "', ", i_damage, ")", sep = "")
#     
#     # Execute the SQL statement
#     dbExecute(db_connection, sql)
#   }
# }
# 
# # Specify the path to your CSV file
# csv_file <- 'Witherspoon.csv'
# 
# # Load CSV data into the database
# load_csv_to_database(csv_file, dbcon)

### END

# Specify the path to your CSV file
csv_file <- 'bird_strikes.csv'

load_csv_to_database <- function(csv_file, con) {
  
  txnFailed = FALSE

  
  # Read CSV file
  csv_data <- read.csv(csv_file)

  
  # The stored procedure to be created
  dropprocedure <- "DROP PROCEDURE IF EXISTS AddNewStrike;"
  dbSendQuery(con, dropprocedure)
  

# Mine Procedure
  
#   procedure <- "
# CREATE PROCEDURE AddNewStrike(
#      IN p_flight_date DATE,
#     IN p_airline VARCHAR(255),
#     IN p_origin_state VARCHAR(255),
#     IN p_aircraft VARCHAR(255),
#     IN p_altitude INT,
#     IN p_numbirds INT,
#     IN p_impact VARCHAR(255),
#     IN p_damage BOOLEAN,
#     IN p_conditions VARCHAR(255),
#     IN p_heavy BOOLEAN
# )
# BEGIN
#     DECLARE v_airport_id INT;
#     DECLARE v_flight_id INT;
#     DECLARE v_conditions_id INT;
# 
#     SELECT aid INTO v_airport_id FROM airports WHERE airportState = p_origin_state;
# 
#     IF v_airport_id IS NULL THEN
#         INSERT INTO airports (airportState) VALUES (p_origin_state);
#         SET v_airport_id = LAST_INSERT_ID();
#     END IF;
# 
#     SELECT fid INTO v_flight_id FROM flights WHERE date = p_flight_date AND airline = p_airline AND origin = v_airport_id;
# 
#     IF v_flight_id IS NULL THEN
#         INSERT INTO flights (date, origin, airline, aircraft, altitude, heavy) VALUES (p_flight_date, v_airport_id, p_airline, p_aircraft, p_altitude, p_heavy);
#         SET v_flight_id = LAST_INSERT_ID();
#     END IF;
# 
#     SELECT cid INTO v_conditions_id FROM conditions WHERE sky_condition = p_conditions;
# 
#     IF v_conditions_id IS NULL THEN
#         INSERT INTO conditions (sky_condition) VALUES (p_conditions);
#         SET v_conditions_id = LAST_INSERT_ID();
#     END IF;
# 
#     INSERT INTO strikes (fid, numbirds, impact, damage, altitude, conditions)
#     VALUES (v_flight_id, p_numbirds, p_impact, p_damage, p_altitude, v_conditions_id);
# 
# END;
# "

  procedure <- "
  CREATE PROCEDURE AddNewStrike(
    IN I_airportState VARCHAR(50),
    IN I_sky_condition TEXT,
    IN I_date DATE,
    IN I_airline VARCHAR(50),
    IN I_aircraft TEXT,
    IN I_altitude INTEGER,
    IN I_heavy TINYINT(1),
    IN I_numbirds INTEGER,
    IN I_impact TEXT,
    IN I_damage TINYINT(1)
  )
  BEGIN
  -- Declare variables for IDs of new records
  DECLARE airport_id INT;
  DECLARE flight_id INT;
  DECLARE conditions_id INT;
  DECLARE strike_id INT;
  
  -- Check if the airport already exists
  SELECT aid INTO airport_id FROM airports WHERE airportState = I_airportState;
  
  -- If the airport does not exist, insert a new record
  IF airport_id IS NULL THEN
  SET airport_id = (SELECT MAX(aid)+1 FROM airports);
  INSERT INTO airports (aid, airportState) VALUES (airport_id, I_airportState);
  END IF;
  
  -- Check if the conditions already exist
  SELECT cid INTO conditions_id FROM conditions WHERE sky_condition = I_sky_condition;
  
  -- If the conditions do not exist, insert a new record
  IF conditions_id IS NULL THEN
  SET conditions_id = (SELECT MAX(cid)+1 FROM conditions);
  INSERT INTO conditions (cid, sky_condition) VALUES (conditions_id, I_sky_condition);
  END IF;
  
  -- Check if the flight already exist
  SELECT fid INTO flight_id FROM flights WHERE date = I_date AND aircraft = I_aircraft AND airline = I_airline AND origin = airport_id;
  
  -- Insert a new flight record
  IF flight_id IS NULL THEN
  SET flight_id = (SELECT MAX(fid)+1 FROM flights);
  INSERT INTO flights (fid, date, origin, airline, aircraft, altitude, heavy) VALUES (flight_id, I_date, airport_id, I_airline, I_aircraft, I_altitude, I_heavy);
  END IF;
  
  -- Insert a new strike record
  SET strike_id = (SELECT MAX(sid)+1 FROM strikes);
  INSERT INTO strikes(sid,fid,numbirds,impact,damage,altitude,conditions) VALUES (strike_id, flight_id, I_numbirds, I_impact, I_damage, I_altitude, conditions_id);
  
  END;  
  "
  
  
# Run the stored procedure
dbSendQuery(con, procedure)

    
  # Loop through each row in the CSV data and insert into the database
  for (i in 1:nrow(csv_data)) {
    # Get the values from the current row
    i_airport_state <- csv_data[i, "origin"]
    i_sky_condition <- csv_data[i, "sky_conditions"]
    i_date <- csv_data[i, "flight_date"]
    i_airline <- csv_data[i, "airline"]
    i_aircraft <- csv_data[i, "model"]
    i_altitude <- csv_data[i, "altitude_ft"]
    i_heavy <- csv_data[i, "heavy_flag"]
    i_numbirds <- csv_data[i, "wildlife_struck"]
    i_impact <- csv_data[i, "impact"]
    i_damage <- csv_data[i, "damage"]
    
    # Data processing
    i_date <- as.Date(i_date, format = "%m/%d/%Y %H:%M")
    
    if (i_heavy == "Yes"){
      i_heavy <- 1
    } else if (i_heavy == "No") {
      i_heavy <- 0
    } else {
      i_heavy <- -1
    }
    
    if (i_damage == "Caused damage"){
      i_damage <- 1
    } else if (i_damage == "No damage"){
      i_damage <- 0
    } else {
      i_damage <- -1
    }
    
    i_altitude <- sub(",", "", i_altitude)
    i_altitude <- as.numeric(i_altitude)
    
    if(i_airline == ""){
      i_airline <- "unknown"
    }
    
    if(i_aircraft == ""){
      i_aircraft <- "unknown"
    }
    
    print(i_airport_state)
    
    # Prepare the SQL statement for calling the stored procedure
    sql <- paste("CALL AddNewStrike('", i_airport_state, "', '", i_sky_condition, "', '",
                 i_date, "', '", i_airline, "', '", i_aircraft, "', ", i_altitude, ", ",
                 i_heavy, ", ", i_numbirds, ", '", i_impact, "', ", i_damage, ")", sep = "")

    # sql <- paste("CALL AddNewStrike('", i_date, "', '", i_airline, "', '",
    #              i_airport_state, "', '", i_aircraft, "', '", i_altitude, "', ", i_numbirds, ", ",
    #              i_impact, ", ", i_damage, ", '", i_sky_condition, "', ", i_heavy, ")", sep = "")
    # 
    # Execute the SQL statement
    
    
    
    dbExecute(con, "BEGIN")
    
    # Try to execute the insert statement
    tryCatch({
      dbExecute(con, sql)
      # If the insert is successful, commit the transaction
      dbExecute(con, "COMMIT")
    }, error = function(e) {
      # If there's an error, rollback the transaction
      dbExecute(con, "ROLLBACK")
      #print or log the error message
      print(paste("Error in row", i, ": ", e$message))
    })
  }
} 
    
load_csv_to_database(csv_file, con)
       
#     dbExecute(con, sql)
#     
#   }
#   
#   # Return
#   return(!txnFailed)
# }

# # Specify the path to your CSV file
# csv_file <- 'bird_strikes.csv'

# Set autocommit to false
# dbExecute(con, "SET AUTOCOMMIT=0")
# 
# # Begin Transaction
# dbExecute(con, "BEGIN")
# 
# if(!(load_csv_to_database(csv_file, con))) {
#   dbExecute(con,"ROLLBACK")
# } else {
#   dbExecute(con,"COMMIT")
# }



sql <- paste("SELECT s.sid, s.fid, s.numbirds, s.impact, s.damage, s.altitude, s.conditions, f.date, f.origin, f.airline, f.aircraft, f.heavy
FROM strikes s JOIN flights f ON f.fid = s.fid
ORDER BY sid DESC
LIMIT 20;")

#Execute the SQL statement
dbGetQuery(con, sql)



# Close the database connection
dbDisconnect(con)


# SELECT s.sid, s.fid, s.numbirds, s.impact, s.damage, s.altitude, s.conditions, f.date, f.origin, f.airline, f.aircraft, f.heavy
# FROM strikes s JOIN flights f ON f.fid = s.fid
# ORDER BY sid DESC
# LIMIT 11;




