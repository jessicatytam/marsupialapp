#specieshindex libraries
library(taxize)
library(httr)
library(XML)
library(rscopus)
library(secret)
devtools::install_github("jessicatytam/specieshindex", force = T)
library(specieshindex)
#table libraries
library(reactable)
library(formattable)
#data wrangling libraries
library(dplyr)
library(stringr)

#loading hidden API key
vault <- file.path(".vault")
key_dir <- file.path(system.file(package = "secret"), "user_keys")
public_key <- file.path(key_dir, "jesst.pub")
private_key <- file.path(key_dir, "jesst.pem")
myAPI <- get_secret("myAPI", key = private_key, vault = vault) #loading my hidden API key

#load taxonomy data
taxonomy <- read.csv(file = "taxonomy.csv", header = T)

#loop function to download citation data
DownloadAll <- function(data) {
  totalspp <- nrow(data)
  APIkey <- myAPI
  datalist = list()
  print("Starting loop now.")
  for (i in 1:totalspp) {
    print(i)
    species <- FetchSpTAK(data$genusName[i],
                          data$speciesName[i], 
                          APIkey)
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
  mutate(Family = str_to_title(tolower(taxonomy$familyName))) %>%
  mutate(Order = str_to_title(tolower(taxonomy$orderName))) %>%
  mutate(Class= str_to_title(tolower(taxonomy$className)))

#reordering and tidying the dataset
marsupial_df <- marsupial_df[,c(1:3,14:16,4:13)] %>%
  mutate(genus_species = str_replace_all(genus_species, "[[:punct:]]", " ")) %>%
  rename("Binomial name" = genus_species,
         "Species" = species,
         "Genus" = genus,
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
#credits to [Tim Bock] (https://www.displayr.com/formattable/)
unit.scale = function(x) (x - min(x)) / (max(x) - min(x))

#the table
formattable(marsupial_df, list(
  "h-index" = color_bar("#FF9E9E", fun = unit.scale),
  "m-index" = color_bar("#FFE49E", fun = unit.scale),
  "i10 index" = color_bar("#9EFFAF", fun = unit.scale),
  "h5 index" = color_bar("#9EDBFF", fun = unit.scale)
))
