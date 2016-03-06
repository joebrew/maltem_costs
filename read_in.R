# No scientific notation
options(scipen=999)

#####
# PACKAGES
#####
library(ggthemes)
library(dplyr)
library(xtable)
library(ggplot2)
library(knitr)
library(png)
library(grid)
library(extrafont)
library(tidyr)
library(gridExtra)
library(readxl)
library(raster)
library(maptools)
library(rgeos)
library(readxl)
library(readr)
source('helpers.R')

if('cleaned_data.RData' %in% dir()){
  load('cleaned_data.RData')
} else {
  
  # READ IN OVERALL COST DATA
  df <- read_excel('data/Cost.xls')
  
  # Clean up the issue with sub-awards
  df$Concepto <- tolower(df$Concepto)
  df$OBJReal[grepl('sub-awards', df$Concepto)] <-
    'IRS'
  
  # Subset for MDA
  mda <- df %>% 
    filter(OBJReal == 'MDA')
  
  # MDA needs items cleaned up
  # Office material needs to be combined
  # Office furniture WITHIN Office material
  # Laptop and accessories ADINS de Office material
  # Do by percentage, not dollars
  mda$Item <- 
    ifelse(grepl('Office|Laptop', mda$Item), 'Office', mda$Item)
  mda$Item[grepl('Laboratory supplies', mda$Item)] <- 'Lab supplies (inc. transport)'
  mda$Item[grepl('General and administrative', mda$Item)] <- 'Gen/Adm services'
  mda$Item[grepl('Catering and', mda$Item)] <- 'Catering and facilities'
  
  
  # IRS data
  total_direct_costs <-  465999.19 
  irs <- read_csv('data/irs_page_5.csv')
  
  
  #####
  # GET SPATIAL DATA
  moz3 <- getData('GADM', country = 'MOZ', level = 3)
  maputo <- moz3[moz3@data$NAME_1 %in% c('Maputo', 'Maputo City'),]
  # Fortify maputo
  maputo_fortified <- fortify(maputo, region = 'NAME_3')
  # Fortify moz3
  moz3_fortified <- fortify(moz3, region = 'NAME_3')
  
  save.image('cleaned_data.RData')
  
}