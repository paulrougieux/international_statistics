# This script loads data from the eurostat website
# Author: Paul Rougieux, European Forest Institute
#
# Input: EUROSTAT website accessed with thelibrary SmarterPoland
# Output: Rdata files containing the datasets as data frames



# This package makes it possible to download Eurostat data. 
# 
# For example to download a data frame containing forest sector employment data:
#     library(SmarterPoland)
# for_emp_lfs = getEurostatRCV(kod = "for_emp_lfs")
# 
# Table codes can be searched in the Eurostat Table of content with the  grepEurostatTOC() function. The getEurostatTOC() function returns the full table of content.

library(SmarterPoland)

#############################################################
# Load EUROSTAT Table of Content for Forest related dataset #
#############################################################
# Download a table of contents of eurostat datasets.
# Note that the values in column ’code’ should be used to download a selected dataset.
toc = getEurostatTOC()

# Forestry datasets and folders starting with the code "for_"
toc_for = toc[grep("for_", toc$code), ]

# Check what datasets with title containing the word "forest", "wood" or "paper" 
# do not start with the code "for_":
checkIfNotIntoc_for = function(dtf){
    # Aesthetic: trim leading whitespace in title
    dtf$title = gsub("^\\s+","",dtf$title) 
    dtf[!dtf$code %in% toc_for$code,c(1,2)]
}
checkIfNotIntoc_for(grepEurostatTOC("forest")) 
checkIfNotIntoc_for(grepEurostatTOC("paper")) 
checkIfNotIntoc_for(grepEurostatTOC("wood")) 


#############################
# Dowload EUROSTAT datasets #
#############################
# Download Roundwood production and trade
for_basic = getEurostatRCV(kod = "for_basic")

# Download employment data
for_emp_lfs = getEurostatRCV(kod = "for_emp_lfs")
for_emp_lfs1 = getEurostatRCV(kod = "for_emp_lfs1")


##################################################################
# Load and Transform eurMap to a data frame for use with ggplot2 #
##################################################################



##############################
# Save datasets in ./rawdata #
##############################
# save datasets starting with "for_" to an R archive
save(list = ls(pattern="for_"), file="rawdata/EUROSTAT_forestry.RDATA")

