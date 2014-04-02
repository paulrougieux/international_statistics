library(FAOSTAT)
source("code/func.R")

######################### #
# Bilateral trade data ####
######################### #
# Rename products
load("rawdata/roundwood_tropical_cam_indo_us.RDATA")
roundwood_4_countries$partner_country <- as.character(roundwood_4_countries$partner_country)

# Rename Ind Rwd Wir (NC) products
# April 2014 comment : leave this for a later stage

replacecountrynames <- function(dtf){
    # Which countries are not in the FAOcountryProfile table ?
    print(unique(dtf$partner_country[!dtf$partner_country
                                     %in% FAOcountryProfile$FAO_TABLE_NAME]))
    # Replace Ivory coast
    dtf$partner_country[grepl("voire",dtf$partner_country)] <- 
        FAOcountryProfile$FAO_TABLE_NAME[grepl('voire',FAOcountryProfile$FAO_TABLE_NAME)]
    
    # Replace Cape verde
    dtf$partner_country[dtf$partner_country == "Cabo Verde"] <- 
        FAOcountryProfile$FAO_TABLE_NAME[grepl('Verde',FAOcountryProfile$FAO_TABLE_NAME)]
    
    print("After replacement")
    print(unique(dtf$partner_country[!dtf$partner_country
                                                          %in% FAOcountryProfile$FAO_TABLE_NAME]))
}

replacecountrynames(roundwood_4_countries)


# Add partner_continent column - Put this in a function
# Add  FAOST_CODE from FAOcountryProfile 

# Add UNSD_MACRO_REG from FAOregionProfile
unique(FAOregionProfile$UNSD_MACRO_REG)

# Add maybe UNSD_SUB_REG
unique(FAOregionProfile$UNSD_SUB_REG)
