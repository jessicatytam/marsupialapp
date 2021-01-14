#specieshindex libraries
library(taxize)
library(httr)
library(XML)
library(rscopus)
library(secret)
devtools::install_github("jessicatytam/specieshindex", force = TRUE, build_vignettes = FALSE)
library(specieshindex)
#data wrangling libraries
library(dplyr)
library(stringr)
#table libraries
library(reactable)
library(formattable)

#load taxonomy data
taxonomy <- read.csv(file = "IUCN_data/taxonomy.csv", header = T)

#loop function to download citation data
DownloadAll <- function(data) {
  totalspp <- nrow(data)
  APIkey <- "442b9048417ef20cf680a0ae26ee4d86"
  datalist = list()
  print("Starting loop now.")
  for (i in 1:totalspp) {
    print(i)
    species <- FetchSpTAK(data$genusName[i],
                          data$speciesName[i], 
                          APIkey = APIkey)
    sppindex <- Allindices(species, genus = data$genusName[i], species = data$speciesName[i])
    print(paste(length(species), "records retrieved."))
    datalist[[i]] <- sppindex
  }
  return(datalist)
}

#convert from list to df
marsupials <- DownloadAll(taxonomy)
marsupial_df <- bind_rows(marsupials)

#adding taxonomic levels
marsupial_df <- marsupial_df %>%
  mutate(family = str_to_title(tolower(taxonomy$familyName)),
         order = str_to_title(tolower(taxonomy$orderName)),
         class= str_to_title(tolower(taxonomy$className)),
         .after = genus)

write.csv(marsupial_df, file = "outputs/marsupial_df.csv")

marsupial_df <- read.csv(file = "outputs/marsupial_df.csv", header = T)[-c(1)]

#reordering and tidying the dataset
marsupial_table <- marsupial_df[,c(1:3,14:16,4:13)] %>%
  mutate(genus_species = str_replace_all(genus_species, "[[:punct:]]", " ")) %>%
  rename("Binomial name" = genus_species,
         "Species" = species,
         "Genus" = genus,
         "Family" = family,
         "Order" = order,
         "Class" = class,
         Publications = publications,
         Citations = citations,
         Journals = journals,
         Articles = articles,
         Reviews = reviews,
         "Years publishing" = years_publishing,
         "h-index" = h,
         "m-index" = m,
         "i10 index" = i10,
         "h5 index" = h5)


#function to scale the colour bar
#from [Tim Bock] (https://www.displayr.com/formattable/)
unit.scale = function(x) (x - min(x)) / (max(x) - min(x))

#the table
formattable(marsupial_table, list(
  "h-index" = color_bar("#FF9E9E", fun = unit.scale),
  "m-index" = color_bar("#FFE49E", fun = unit.scale),
  "i10 index" = color_bar("#9EFFAF", fun = unit.scale),
  "h5 index" = color_bar("#9EDBFF", fun = unit.scale)
))

