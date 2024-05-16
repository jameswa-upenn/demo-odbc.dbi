dataImage <- "dataImage.Rdata"

if(file.exists(dataImage)) { 
   load(dataImage) # load the previously saved workspace
}  

var_max_days_stale <- 0 # adjust to refresh sourceSQL.R data if stale > 'X' days

# function to load sql script into dataframe
loadSQLQuery <- function(qname) { 
  connection <- DBI::dbConnect(odbc::odbc(), dsn="whse", uid=Sys.getenv("userid"), pwd=Sys.getenv("pwd"))
  sqlFile <- str_c(qname, ".sql") # ^ https://db.rstudio.com/best-practices/deployment/#credentials-inside-environment-variables-in-rstudio-connect
  query <- readChar(sqlFile, file.info(sqlFile)$size)
  result <- dbGetQuery(connection, query)
  dbDisconnect(connection)
  result
}

# directory location for queries (to be recycled)
directory <- str_c(workingDirectory, "sql", sep="/")

# qnames: vector of all sql queries to be run:
# *** note that if file name is "population.sql", vector element should be "population"
#     vector may contain 1 + x number of values (sql query names)

qnames <- c(
            str_c(directory, "some_query_name_here", sep= "/")
          , str_c(directory, "some_other_query_name", sep= "/")
          , str_c(directory, "the_third_query_name", sep= "/")
           )

if(!file.exists("dataImage.Rdata") | as.Date(file.info("dataImage.Rdata")$mtime)<as.Date(Sys.time())-var_max_days_stale) {
# run each query, add each result to list   
  dataList <- as.list(qnames) %>%
    map(loadSQLQuery) %>% # map() takes a vector (dataList here) as input & applies function (loadSQLQuery() here) to each element of the vector
    setNames(str_remove(str_remove(qnames, directory), "/")) # name list items to match query names
  save.image(dataImage)
  
}

dataDt <- as.Date(file.info("dataImage.Rdata")$mtime)
