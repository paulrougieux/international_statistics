# This script loads data from the UN COMTRADE website
# Author: Paul Rougieux, European Forest Institute
#
# Input: csv or sdmx files
# Output: data frames stored in a .RDATA file
#
library("rjson")

# Background information
# http://unstats.un.org/unsd/tradekb/Knowledgebase/HS-Classification-by-Section


###############
# UN data api #
###############
# ID and keys available on 
# https://www.undata-api.org/docs
#
# !!!! Store this key in an external script, not backed up on github!!!
# Or better, use a function to ask the user for app_id and app_key each time they load data.

message("Please enter API credentials available on www.undata-api.org")
app_id <-  readline("app_id: ")
app_key <- readline("app_key: ")

# Returns an array of organizations
download.file(paste0("http://api.undata-api.org/organizations?app_id=", app_id, 
                     "&app_key=", app_key),
              destfile="rawdata/UNDATA_Organisations.JSON")


# Return an array of datasets that belong to the organization
download.file(paste0("http://api.undata-api.org/UNSD/datasets?app_id=", app_id, 
                     "&app_key=", app_key),
              destfile="rawdata/UNSD_datasets.JSON")
datasets_json <- fromJSON(paste(readLines("rawdata/UNSD_datasets.JSON"), collapse=""))

# In case do.call("rbind" doesn't work, you might need to add NA values
# see http://stackoverflow.com/questions/16947643/getting-imported-json-data-into-a-data-frame-in-r
un_datasets <- do.call("rbind", datasets_json)
# Check for wood or paper datasets
un_datasets[grep("wood", un_datasets,  ignore.case = TRUE),]
un_datasets[grep("paper", un_datasets, ignore.case = TRUE),]
un_datasets[grep("furniture", un_datasets, ignore.case = TRUE),]
un_datasets[grep("import", un_datasets, ignore.case = TRUE),]

# Get the names of all the countries that are in the dataset
download.file(paste0("http://api.undata-api.org/UNSD/Sawnwood, coniferous/countries?app_id=", app_id, 
                     "&app_key=", app_key),
              destfile="rawdata/sawnwood_countries.JSON")
sawnwood_countries <- do.call("rbind", fromJSON(paste(readLines("rawdata/sawnwood_countries.JSON"), collapse="")))

# Get records for coniferous sawnwood in France
download.file(paste0("http://api.undata-api.org/UNSD/Sawnwood, coniferous/France/records?app_id=", app_id, 
                     "&app_key=", app_key),
              destfile="rawdata/sawnwoodC_France.JSON")
sawnwoodC_fr <- do.call("rbind", fromJSON(paste(readLines("rawdata/sawnwoodC_France.JSON"), collapse="")))


# Get records for furniture in France
download.file(paste0("http://api.undata-api.org/UNSD/Wooden furniture of a kind used in the bedroom/France/records?app_id=", app_id, 
                     "&app_key=", app_key),
              destfile="rawdata/FurnitureBed_France.JSON")
furnitureBed_fr <- do.call("rbind", fromJSON(paste(readLines("rawdata/sawnwoodC_France.JSON"), collapse="")))




#####################################################################
# Based on http://technistas.com/2012/06/11/using-rest-apis-from-r/ #
# #####################################################################

##############################
#### Old stuff pre 2013 ######
##############################
# # Try to download a SDMX file from UNCOMTRADE
# # It seems it's an HTML file instead of the csv data that  I want
# download.file("http://comtrade.un.org/db/dqBasicQueryResultsd.aspx?action=sdmx&cc=TOTAL&px=H2&r=372&y=2006", 
#               destfile="rawdata/comtrade_Ireland_Exports")
# 
# download.file("http://comtrade.un.org/db/get.aspx?cc=TOTAL&px=H2&r=372&y=2006", 
#               destfile="rawdata/comtrade_Ireland_exports")
# 
# 
# download.file("http://comtrade.un.org/db/dqBasicQueryResultsd.aspx?action=csv&px=HS&cc=44&r=251&p=0&rg=1&y=2012,2011,2010,2009,2008&so=8",
#               destfile="rawdata/france_Wood_imports.csv")
# 
# # a UN help page tells to replace dqBasicQueryResultsd.aspx? by get.aspx?
# # But this is only accessible by authentication.
# 
# # A password is needed
# download.file("http://comtrade.un.org/db/get.aspx?action=sdmx&cc=TOTAL&px=H2&r=372&y=2006", 
#               destfile="rawdata/comtrade_Ireland_Exports")
# 
# # Try to download a csv file from UNCOMTRADE
# download.file("http://comtrade.un.org/db/dqBasicQueryResultsd.aspx?action=csv&cc=TOTAL&px=H2&r=372&y=2006",
#               destfile="rawdata/comtrade_Ireland_Exports.csv")
# 

# Data-Extraction-Using-Comtrade-Web-Service
# http://unstats.un.org/unsd/tradekb/Knowledgebase/Data-Extraction-Using-Comtrade-Web-Service
# Web Service Methods and Parameters
# 
# To access REST web service, you need page name (method) and query string (parameter).
# In fact, UN Comtrade database was built based on query string, 
# such result page of Ireland Total Export in 2006
# (http://comtrade.un.org/db/dqBasicQueryResults.aspx?cc=TOTAL&px=H2&r=372&y=2006).
# 
# dqBasicQueryResults.aspx is the page name (method to show result) and cc=TOTAL&px=H2&r=372&y=2006 are the query strings, of which cc is commodity code, px is commodity classification, r is reporter and y is year.
# 
# In order to get the result via web service, you need to change dqBasicQueryResults.aspx to get.aspx (for Element-Based-XML format) or getSdmxV1.aspx (for SDMX format) and change /db to /ws (web service) and add comp=false (set compression flag to disable, so that it can be viewed on a browser):
#     (http://comtrade.un.org/ws/get.aspx?cc=TOTAL&px=H2&r=372&y=2006&comp=false or http://comtrade.un.org/ws/getSdmxV1.aspx?cc=TOTAL&px=H2&r=372&y=2006&comp=false
#      or for those who like to use authorization code
#      http://comtrade.un.org/ws/getSdmxV1.aspx?cc=TOTAL&px=H2&r=372&y=2006&comp=false&code=yourcode
#     )
# 
# Here is the list of common query string parameters:
#     
#     Px = Commodity Classification
# R = Reporter
# Y = Year
# CC = Commodity Code
# P = Partner Country
# Rg = Trade Flow

# Try loading Irish exports dataset
# Doesn't work, object moved
Ireland = getURL("http://comtrade.un.org/db/dqBasicQueryResults.aspx?cc=TOTAL&px=H2&r=372&y=2006")
Ireland = getURL("http://comtrade.un.org/db/syslogin.aspx?ReturnUrl=%2fdb%2fdqBasicQueryResults.aspx%3fcc%3dTOTAL%26px%3dH2%26r%3d372%26y%3d2006&amp;cc=TOTAL&amp;px=H2&amp;r=372&amp;y=2006")
