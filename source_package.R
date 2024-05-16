workingDirectory <- getwd()

if(!suppressWarnings(require(pacman))) {
  install.packages("pacman")
  require(pacman)
}

pacman::p_load(DBI # https://solutions.posit.co/connections/db/r-packages/dbi/
             , odbc # https://solutions.posit.co/connections/db/r-packages/odbc/
             , tidyverse
              ) # add packages/libraries here as needed