
#
# Functions copied from other project:
# forestproductsdemand 
# https://github.com/paul4forest/forestproductsdemand
# Edit original verion there firts
#

#
# Functions to download forest products data from FAOSTAT
# using the FAOSTAT module
# Author: Paul Rougieux, European Forest Institute

library(FAOSTAT)

FAO <- list() # A list of FAO functions and metadata

################
# FAO metadata #
################
# Element contain the production and trade flow codes
FAO$elementTable <- subset(FAOmetaTable$elementTable, domainCode=="FO")

# Item contain the product codes 
FAO$itemTable <- subset(FAOmetaTable$itemTable, domainCode=="FO")
FAO$itemAggTable <- subset(FAOmetaTable$itemAggTable, domainCode=="FO")

# Country codes an names
FAO$countrycodes <- subset(FAOcountryProfile, 
                           !is.na(FAOST_CODE), # Remove codes which are not avaible
                           select=c(FAOST_CODE, FAO_TABLE_NAME))
names(FAO$countrycodes) <-  c("FAOST_CODE", "Country")
# Add macro region and sub region names for each country
FAO$countrycodes <- merge(FAO$countrycodes,
                          FAOregionProfile[c("FAOST_CODE","UNSD_MACRO_REG","UNSD_SUB_REG")])

# Table of region codes and names for country aggregates
# This table is not present in the FAOSTAT module

# !! year of entry into the EU is not the real year of entry for EU countries
# areagroup <- read.csv("rawdata/FAOstatAreaGroupList.csv")
# regioncodes_from_csv <- unique(areagroup[c("FAOST_REG_CODE", "Region")])

# Hardcoded this small data frame so that it's platform independent.
FAO$regioncodes <-  structure(list(FAOST_CODE = c(5000L, 
                                                  5100L, 5101L, 5102L, 5103L, 5104L, 5105L, 5200L, 5203L, 5204L, 
                                                  5206L, 5207L, 5300L, 5301L, 5302L, 5303L, 5304L, 5305L, 5400L, 
                                                  5401L, 5402L, 5403L, 5404L, 5500L, 5501L, 5502L, 5503L, 5504L, 
                                                  5600L, 5706L, 5801L, 5802L, 5803L, 5815L, 5817L, 5848L, 5849L), 
                                   Region = structure(c(37L, 1L, 10L, 20L, 23L, 31L, 34L, 2L, 
                                                        24L, 8L, 7L, 30L, 5L, 9L, 11L, 32L, 29L, 35L, 13L, 12L, 25L, 
                                                        33L, 36L, 26L, 6L, 18L, 19L, 27L, 4L, 14L, 16L, 15L, 28L, 17L, 
                                                        21L, 3L, 22L),
                                                      .Label = c("Africa", "Americas", "Annex I countries", 
                                                                 "Antarctic Region", "Asia", "Australia and New Zealand", "Caribbean", 
                                                                 "Central America", "Central Asia", "Eastern Africa", "Eastern Asia", 
                                                                 "Eastern Europe", "Europe", "European Union", "LandLocked developing countries", 
                                                                 "Least Developed Countries", "Low Income Food Deficit Countries", 
                                                                 "Melanesia", "Micronesia", "Middle Africa", "Net Food Importing Developing Countries", 
                                                                 "Non-Annex I countries", "Northern Africa", "Northern America", 
                                                                 "Northern Europe", "Oceania", "Polynesia", "Small Island Developing States", 
                                                                 "South-Eastern Asia", "South America", "Southern Africa", "Southern Asia", 
                                                                 "Southern Europe", "Western Africa", "Western Asia", "Western Europe", 
                                                                 "World"),
                                                      class = "factor")),
                              .Names = c("FAOST_CODE", "Region"
                              ), row.names = c(1L, 255L, 316L, 338L, 347L, 355L, 360L, 377L, 
                                               431L, 436L, 444L, 470L, 484L, 536L, 541L, 550L, 559L, 570L, 588L, 
                                               642L, 654L, 668L, 686L, 696L, 725L, 730L, 735L, 743L, 754L, 756L, 
                                               784L, 835L, 866L, 919L, 984L, 1065L, 1108L),
                              class = "data.frame")


##############################
# Functions to load FAO data #
##############################
# Function that finds an item name given its code
FAO$itemname <- function(itemcode){
    i = subset(FAOmetaTable$itemTable, itemCode==itemcode&domainCode=="FO")
    agg = subset(FAOmetaTable$itemAggTable, itemCode==itemcode&domainCode=="FO")
    if(nrow(i)== 1){
        name = i$itemName }
    if(nrow(agg)== 1){
        name = agg$itemName }
    return(name)
}

# Function to batch download production and trade quantity and value
# This function downloads data from FAOSTAT using getFAOtoSYB()
# Download all data for one product, that means one item and 5 elements
FAO$download <- function(item, elem1, elem2, elem3, elem4, elem5){
    FAOquery.df <- data.frame(varName = c("Production",
                                          "Import_Quantity", "Import_Value",
                                          "Export_Quantity", "Export_Value"),
                              domainCode = "FO",
                              itemCode = item,
                              elementCode = c(elem1, elem2, elem3, elem4, elem5),
                              stringsAsFactors = FALSE)
    FAO.lst <- with(FAOquery.df,
                    getFAOtoSYB(name = varName, domainCode = domainCode,
                                itemCode = itemCode, elementCode = elementCode))
    
    #Add country and region names
    FAO.lst$entity <- merge(FAO$countrycodes[c("FAOST_CODE", "Country")], FAO.lst$entity)
    FAO.lst$aggregates <- merge(FAO$regioncodes, FAO.lst$aggregates, all.y = TRUE)
    
    # Add item names
    FAO.lst$entity$Item <- FAO$itemname(item)
    FAO.lst$aggregates$Item <- FAO$itemname(item)
    return(FAO.lst)
}


