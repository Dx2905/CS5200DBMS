#CS5200 S23- Gaurav


#Assumption: files to be copied are in folder "filestocopy"

# Declare and initialize global variables
globalVar <- 0
rootDir <- "docDB"

main <- function() {

  print("Hello, World")

  # Test the functions

  # Configure the database
  configDB(rootDir, "")


  # Test the getTags function
  print(genObjPath(rootDir, "#ISEC"))

  # Test the genObjPath function
  print(getTags("CampusAtNight.jpg #Northeastern #ISEC"))

  # Test the getFileName function
  print(getFileName("CampusAtNight.jpg #Northeastern #ISEC"))

  
 
  # The files to be copied are in the folder "filestocopy"
  # Test the storeObjs function
  storeObjs("filestocopy", rootDir)
  
  # Clear the database
  clearDB(rootDir)
  
  
  # Test the storeObjs function with verbose
  storeObjs("filestocopy", rootDir, verbose = TRUE)
  
 
}

# Function to configure the database structure
configDB <- function(root, path) {
  # Check if the path argument is empty
  if (path == "") {

    # Print the current working directory
    print(getwd())

    # Create the root directory in the current working directory
    dir.create(root)
  } else {

    # Create the root directory under the provided path
    dir.create(file.path(path, root))
  }

}

# Function to generate the object path for a tag
genObjPath <- function(root, tag) {
  
  # Append the tag to the root directory, removing the "#" symbol
  return(paste0(root, "/", gsub("#", "", tag)))
}

# Function to extract tags from a file name
getTags <- function(fileName) {
  
  # Define the pattern to match tags (e.g., "#Northeastern")
  pattern <- "(#[a-zA-Z0-9]+)"
  
  # Use gregexpr to find matches of the pattern in the file name
  matches <- gregexpr(pattern, fileName)
  
  # Extract the matched tags
  tags <- regmatches(fileName, matches)[[1]]
  return(tags)
}

# Function to extract the file name from a file name with tags
getFileName <- function(fileName) {
  
  # Define the pattern to capture the file name portion
  pattern <- "(.+?)(\\s#.*)?$"
  
  # Use regexec to find matches of the pattern in the file name
  matches <- regexec(pattern, fileName)
  
  # Check if a match is found
  if (matches[[1]][1] != -1) {
    
    # Extract the file name using substr
    fileName <- substr(fileName, matches[[1]][2], matches[[1]][3] - 1)
  }
  return(fileName)
}

# Function to copy files to their respective tag folders
storeObjs <- function(folder, root, verbose = FALSE) {
  
  # Configure the database
  configDB(rootDir, "")
  
  # Get the list of files in the folder
  files <- list.files(folder)

  for (file in files) {
    # Extract the tags from the file name
    tags <- getTags(file)

    for (tag in tags) {
      
      # Generate the object path for the tag
      objPath <- genObjPath(root, tag)
      
      # Create the tag folder if it doesn't exist
      dir.create(objPath, showWarnings = FALSE)
      
      # Extract the file name without tags
      fileToCopy <- getFileName(file)
      
      # Generate the destination path
      destination <- file.path(objPath, fileToCopy)
      
      # Copy the file to the destination
      file.copy(file.path(folder, file), destination)
      
      
      # Print a verbose message if enabled
      if (verbose) {
        print(paste("Copying", fileToCopy, "to", gsub("#", "", tag)))
      }
    }
  }
}

# Function to clear the database
clearDB <- function(root) {
  
  # Check if the root directory exists
  if (dir.exists(root)) {
    
    # Get the list of files and subdirectories within the root directory
    files <- list.files(root, recursive = TRUE, full.names = TRUE)

    for (file in files) {
      
      # Check if the file/directory exists
      if (file.exists(file)) {
        
        # Check if it is a directory
        if (file.info(file)$isdir) {
          
          # Delete the directory and its contents
          unlink(file, recursive = TRUE)
        } else {
          
          # Delete the file 
          file.remove(file)
        }
      }
    }
    
    # Get the list of subdirectories within the root directory
    subdirs <- list.dirs(root, recursive = FALSE, full.names = TRUE)
    
    for (subdir in subdirs) {
      if (dir.exists(subdir)) {
        # Delete the subdirectory and its contents
        unlink(subdir, recursive = TRUE)
      }
    }
  }
}

main()







