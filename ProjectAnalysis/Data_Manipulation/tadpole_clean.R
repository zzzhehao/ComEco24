# This script clean up the raw data of `Kaulquappen Regenwald_Daten` into a minimal usable data set for further analysis.

library(tidyverse)
library(dplyr)
library(readxl)

path <- "Data/Kaulquappen Regenwald_Daten.xls"

cleanBlankCol <- function(data) {
  data <- data %>% select_if(~!all(is.na(.)))
  return(data)
}

unpackDfList <- function(ls, nm) {
  if (length(ls) != length(nm)) {
    stop("names should have same length as list, ", "list has ", length(ls), " name has ", length(nm))
  }
  for (i in 1:length(nm)) {
    assign(ls[[i]], nm[[i]], envir = .GlobalEnv)
  }
}

# Import
tadpoleHabitatRaw <- read_xls(path, sheet = "stream_habitat_matrix")
tadpoleCommunityRaw <- read_xls(path, sheet = "streams_tadpoles_matrix")
insectCommunityRaw <- read_xls(path, sheet = "streams_insects_matrix")
tadpoleRaw <- list(tadpoleHabitatRaw, tadpoleCommunityRaw, insectCommunityRaw)

names <- c('tadpoleHabitatCleaned', 'tadpoleCommunityCleaned', 'insectCommunityCleaned')

# Cleaning step to all sheets
tadpole_clean <- tadpoleRaw %>% 
  map(., cleanBlankCol)

# Release all to global env
unpackDfList(names, tadpole_clean)

#### Individual cleaning

# Habitat Sheet

# Insect Sheet
colnames(insectCommunityCleaned)[1] <- "stream" 

# Community Sheet
colnames(tadpoleCommunityCleaned)[1] <- "stream" 
tadpoleCommunityCleaned <- tadpoleCommunityCleaned %>% select(-tail(names(.), 7))

# Separate Functional Sheet
tadpoleFuntionalCleaned <- tadpole_clean[[2]] %>%
  select(tail(names(.), 7)) %>%
  cbind('stream' = tadpoleCommunityCleaned$stream, .)


# Clean up env
remove(list = ls()[grep("Raw", ls(), value = FALSE)])
