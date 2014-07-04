# Load FAOSTAT data
# Author Paul Rougieux

library(FAOSTAT)

# Source function from the other project FOREST Products Demand.
source("code/func.R")


#################################### #
# Load wood residues and fuel wood ####
#################################### #
FAO$elementTable
FAO$itemname(1620)
residues <- FAO$download(1620, 5516, 5616, 5622, 5916, 5922)
FAO$itemname(1627)
woodfuelC <- FAO$download(1627, 5516, 5616, 5622, 5916, 5922)
woodfuelNC <- FAO$download(1628, 5516, 5616, 5622, 5916, 5922)


################## #
# Bilateral trade #
################## #
# FAOSTAT module doesn't work, use csv instead

# Column headers to copy
# reporting_country     reporting_code	partner_country	partner_code	item	item_code	element	element_code	year	value
# Check for spaces in column names in Excel =FIND(" ",A1)
# Read from zip file
sawnwood_europe = read.csv(unz("rawdata/sawnwood_flows_Europe.zip", "sawnwood_flows_Europe.csv"),
                           as.is=TRUE)
roundwood_europe = read.csv(unz("rawdata/roundwood_flows_Europe.zip", "roundwood_flows_Europe.csv"),
                            as.is=TRUE)

# Check for spaces in column names
stopifnot(!grepl(" ", names(roundwood_europe)))
stopifnot(!grepl(" ", names(sawnwood_europe)))

sawnwood_trade_us <- read.csv("rawdata/sawnwood_trade_US.csv")
roundwood_4_countries <- read.csv("rawdata/roundwood_tropical_cam_indo_us.csv")


# !! different item and element tables
subset(FAOmetaTable$elementTable, domainCode=="FT")
subset(FAOmetaTable$itemTable, domainCode=="FT")

# I updated to the latest version of FAOSTAT
library(devtools)
install_github(repo = "FAOSTATpackage", username = "mkao006", subdir = "FAOSTAT")

# item code 1651 is present in both FO and FT domain tables
subset(FAOmetaTable$itemTable, itemCode==1651)
# Element code 5616 is present in both FO and FT domain tables
subset(FAOmetaTable$elementTable, elementCode==5616)

# Download works in domainCode = "FO"
# 1651 Ind Rwd Wir (C) 5616     Import Quantity(m3)
rwd <- getFAO(name = "Import", domainCode = "FO", itemCode = 1651, elementCode = 5616)
head(rwd)

# But dowload doesn't work for FT, bilateral trade
# Ind Rwd Wir (C)  Import Quantity(m3)
rwd_bilateral <- getFAO(name = "Import", domainCode = "FT", itemCode = 1651, elementCode = 5616)

# Trying to use the more elaborate function getFAOtoSYB()
rwd_bilateral <- getFAOtoSYB(name = "Import", domainCode = "FT", itemCode = 1651, elementCode = 5616)

# "The specified query has no data, consult FAOSTAT"

FAOquery.df <- data.frame(varName = c("Import_Quantity", "Import_Value",
                                      "Export_Quantity", "Export_Value"),
                          domainCode = "FT",
                          itemCode = item,
                          elementCode = c(elem1, elem2, elem3, elem4),
                          stringsAsFactors = FALSE)
FAO.lst <- with(FAOquery.df,
                getFAOtoSYB(name = varName, domainCode = domainCode,
                            itemCode = itemCode, elementCode = elementCode))


#######################################
# Save loaded datasets to RDATA files #
#######################################
save(residues, file="rawdata/residues.RDATA")
save(woodfuelC, woodfuelNC, file="rawdata/woodfuel.RDATA")
save(sawnwood_trade_us, file="rawdata/sawnwood_trade_us.RDATA")
save(roundwood_4_countries, file = "rawdata/roundwood_tropical_cam_indo_us.RDATA")

save(sawnwood_europe, file = "rawdata/sawnwood_flows_Europe.RDATA")
save(roundwood_europe, file = "rawdata/roundwood_flows_Europe.RDATA")
