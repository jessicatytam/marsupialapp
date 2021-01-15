library(dplyr)
library(stringr)

marsupials <- read.csv(file = "outputs/marsupial_df.csv", header = T)[-c(1)]
iucn <- read.csv(file = "IUCN_data/assessments.csv", header = )

#pick red list category
redlist <- iucn %>%
  select(scientificName, redlistCategory)

redlist <- redlist %>%
  rename(genus_species = scientificName)

#remove underscore in genus_species
marsupials$genus_species <- str_replace_all(marsupials$genus_species, "[[:punct:]]", " ")

#binding
newlist <- merge(marsupials, redlist,
                     by = "genus_species")

newlist <- newlist[c(1:6, 17, 7:16)]
