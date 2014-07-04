library(FAOSTAT)
library(plyr)
source("code/func.R")


EU <- read.csv("rawdata/EUCountries.csv")


######################### #
# Bilateral trade data ####
######################### #
load("rawdata/roundwood_tropical_cam_indo_us.RDATA")
load("rawdata//sawnwood_flows_Europe.RDATA")

# Rename Ind Rwd Wir (NC) products
# April 2014 comment : leave this for a later stage

fao_country <- function(part_of_country_name){
    FAOcountryProfile$FAO_TABLE_NAME[grepl(part_of_country_name, 
                                           FAOcountryProfile$FAO_TABLE_NAME)]
}

replacecountrynames <- function(dtf){
    dtf$partner_country <- as.character(dtf$partner_country)
    dtf$reporting_country <- as.character(dtf$reporting_country)
    # Which countries are not in the FAOcountryProfile table ?
    print(unique(dtf$partner_country[!dtf$partner_country
                                     %in% FAOcountryProfile$FAO_TABLE_NAME]))
    # Replace Ivory coast
    dtf$partner_country[grepl("voire",dtf$partner_country)] <- fao_country("voire")
    
    # Replace Cape verde
    dtf$partner_country[dtf$partner_country == "Cabo Verde"] <- fao_country("Verde")
    
    print("After replacement")
    print(unique(dtf$partner_country[!dtf$partner_country
                                                          %in% FAOcountryProfile$FAO_TABLE_NAME]))
    print(str(dtf))
    return(dtf)
}

roundwood_4_countries <- replacecountrynames(roundwood_4_countries)


########################################################## #
# Add partner_continent column - Put this in a function
# Add  FAOST_CODE from FAOcountryProfile 
########################################################## #
# # Future dvpt could add subregion UNSD_SUB_REG
# unique(FAOregionProfile$UNSD_SUB_REG)

# Add UNSD_MACRO_REG from FAOregionProfile
unique(FAOregionProfile$UNSD_MACRO_REG)
region <- subset(FAOregionProfile,select=c(FAOST_CODE, UNSD_MACRO_REG))
names(region) <- c("reporting_code", "reporting_reg")
sawnwood_europe <- merge(sawnwood_europe,  region, by = "reporting_code")
names(region) <- c("partner_code", "partner_reg")
sawnwood_europe <- merge(sawnwood_europe,  region, by = "partner_code")

# Add EU membership TRUE FALSE
sawnwood_europe$reporting_EU <- sawnwood_europe$reporting_code %in% EU$FAOST_CODE
sawnwood_europe$partner_EU <- sawnwood_europe$partner_code %in% EU$FAOST_CODE


# Save to enddata
save(sawnwood_europe, file="enddata/sawnwood_flows_Europe.RDATA")
save(roundwood_4_countries, file="enddata/roundwood_tropical_cam_indo_us.RDATA")
