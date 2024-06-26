library(tidyverse)
library(dplyr)
library(readxl)

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
tadpoleHabitatRaw <- read_xls("Data/Kaulquappen Regenwald_Daten.xls", sheet = "stream_habitat_matrix")
tadpoleCommunityRaw <- read_xls("Data/Kaulquappen Regenwald_Daten.xls", sheet = "streams_tadpoles_matrix")
insectCommunityRaw <- read_xls("Data/Kaulquappen Regenwald_Daten.xls", sheet = "streams_insects_matrix")
tadpole_raw <- list(tadpoleHabitatRaw, tadpoleCommunityRaw, insectCommunityRaw)

names <- c('tadpoleHabitatCleaned', 'tadpoleCommunityCleaned', 'insectCommunityCleaned')

# Cleaning step to all
tadpole_clean <- tadpole_raw %>% 
  map(., cleanBlankCol)

# Release all to global env
unpackDfList(names, tadpole_clean)

#### Individual cleaning

# Habitat Sheet

# Insect Sheet
colnames(insectCommunityCleaned)[1] <- "stream" 

# Community Sheet
colnames(tadpoleCommunityCleaned)[1] <- "stream" 

# Seperating Functional Sheet
tadpoleFuntionalCleaned <- tadpoleCommunityCleaned %>%
  select(tail(names(.), 7)) %>%
  cbind('stream' = tadpoleCommunityCleaned$stream, .)
