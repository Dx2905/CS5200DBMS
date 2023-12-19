install.packages("XML")
library(XML)

# Path to the XML file
xml_file <- "Gaurav.CS5200.SuF.Grants.xml"

##Q2

tryCatch({
  xml_doc <- xmlParse(xml_file, validate = TRUE)
  print("XML document is valid.")
}, error = function(e) {
  print("XML document is not valid.")
})


##Q3
# Use XPath to select the relationship nodes for John Smith
total_grants <- xpathSApply(xml_doc, "count(//relationship[@rid='R1'])")

# Print the result
print(paste("Total number of grants for John Doe:", total_grants))
